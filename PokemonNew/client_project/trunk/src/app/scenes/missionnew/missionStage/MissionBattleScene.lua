
--local SubtitleMainLayer = require "app.subtitle.SubtitleMainLayer"
local Popup = require 'app.popup.Popup'
local Url = require "app.setting.Url"
-- local BattleSummaryLayer = require("app.scenes.battle.summary.BattleSummaryLayer")
local BattleResultLayer = require("app.scenes.battle.result.panel.BattleResultLayer")
local CommonKnightShowLayer = require "app.common.CommonKnightShowLayer"
local FunctionConst = require("app.const.FunctionConst")

local EffectNode = require "app.effect.EffectNode"

local ConfigHelper = require "app.common.ConfigHelper"

local BattleReportHelper = require "app.scenes.battle.BattleReportHelper"

local TypeConverter = require "app.common.TypeConverter"
local ActivityConst = require("app.const.ActivityConst")
---===========
--关卡战斗场景
---===========
local MissionBattleScene = class("MissionBattleScene", function()
    return display.newScene("MissionBattleScene")
end)
-- pack.msg 战报
-- pack.skip 是否跳过
-- pack.double 倍数
-- pack.battleBg 背景 路径
local BattleLayer = require "app.scenes.battle.BattleLayer"
function MissionBattleScene:ctor()
    self._pack = {}
    self._stageId = 0
    self._isFinish = false
    --self._waitting4NextWave = false
    self._hasEntered = false
    self._battleLayer = nil
    self._battleLayerAdded = false --战斗层是否已经添加
    self:enableNodeEvents()
    self:addtUserBattleListener()--添加全局的事件侦听
    self:addChatFloatNode()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_PLAY_BATTLE, self._playBattle, self)
end

---播放战斗
---@battleReport 战报
---@stageId 关卡ID
---@isFistDownReplay 是否是首杀播放战斗
---@hasEntered 是否有进度
---@oldStageThreeStar 攻打之前是否三星
function MissionBattleScene:playBattle(decodeBuffer, stageId, isFistDownReplay, hasEntered, oldStageThreeStar, isFake)
    assert(type(decodeBuffer) == "table", "invalide decodeBuffer " .. tostring(decodeBuffer))
    assert(type(stageId) == "number", "invalide stageId " .. tostring(stageId))
    assert(type(isFistDownReplay) == "boolean", "invalide isFistDownReplay " .. tostring(isFistDownReplay))

    self._decodeBuffer = decodeBuffer
    --self._nextWaveId = decodeBuffer.next_wave_id
    self._hasEntered = hasEntered

    -- -- 这里记一下是否是多波
    -- -- 默认不是多波
    -- if self._hasNextWave == nil then
    --     self._hasNextWave = false
    -- end

    -- self._hasNextWave = self._hasNextWave or (self._nextWaveId ~= 0)

    -- ---播放多波战斗
    -- if self._waitting4NextWave then
    --     self._battleLayer:reset(decodeBuffer.battle)
    --     self._battleLayer:move()
    --     self._battleLayer:play()
    --     self._waitting4NextWave = false

    --     -- 如果多波结束，则发送新手引导递进事件，表示这个时候可以向服务器发送递进步数的请求了
    --     -- 多波结束，nextWaveId应该恢复为0了
    --     if self._hasNextWave and self._nextWaveId == 0 then
    --         uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false)
    --     end

    --     return
    -- end

    self._isFistDownReplay = isFistDownReplay
    self._stageId = stageId
    self._pack.msg = decodeBuffer.battle
    self._pack.isFake = isFake
    self._pack.skip = oldStageThreeStar and BattleLayer.SkipConst.SKIP_YES or BattleLayer.SkipConst.SKIP_NO
    local mapId = require("app.cfg.story_stage_info").get(self._stageId).in_res

    if not string.find(mapId, ".json") then
        self._pack.battleBg = G_Url:getImage_battleBg(mapId)
    else
        self._pack.battleBg = mapId
    end

    -- 是否是第一次进入
    self._pack.isFirstTime = not self._hasEntered
    
    -- 添加弹幕按钮

    -- local subtitleBtn = nil

    -- if G_SubtitleService:isShow() and G_SubtitleService:isValid(1, 0) then
        
    --     local subtitle = cc.MenuItemImage:create(
    --        Url:getUI_icon("icon90_barrage_01"),
    --        Url:getUI_icon("icon90_barrage_01")
    --     )
    --     subtitleBtn = subtitle

    --     subtitle:setAnchorPoint(cc.p(1, 0.5))
    --     subtitle:setPosition(cc.p(display.width, display.height * 0.8))

    --     subtitle:registerScriptTapHandler(function()
    --         if self._isFinish then return end
    --         Popup.newPopupAtTop(function()
    --             return SubtitleMainLayer.create(1, 0)
    --         end)
    --     end)

    --     local name = display.newTTFLabel({size=20,font=G_Path.getNormalFont(),text=G_LangScrap.get("lang_subtitle_title_title")})
    --     name:setColor(G_ColorsScrap.COLOR_SCENE_DESC_NORMAL)
    --     name:enableOutline(G_ColorsScrap.COLOR_SCENE_OUTLINE, 2)
    --     name:setAnchorPoint(0.5, 0)
    --     subtitle:addChild(name)
    --     name:setPosition(subtitle:getContentSize().width/2, 0)

    --     local menu = cc.Menu:create(subtitle)
    --     self:addChild(menu, 100)
    --     menu:setPosition(cc.p(0, 0))

    -- end

    self._pack.stageId = self._stageId
    self._battleLayer = BattleLayer.create(self._pack, function(event, ...)
        if event == BattleLayer.BATTLE_OPENING_FINISH then 
            --G_SubtitleService:start(1, 0)
            print("BATTLE_OPENING_FINISH")
        elseif event == BattleLayer.BATTLE_FINISH then
            print("BATTLE_FINISH")
            
            --G_SubtitleService:stop(1, 0)

            ----如果是多波战斗
            -- if self._nextWaveId ~= nil and self._nextWaveId ~= 0 then
            --     G_HandlersManager.chapterHandler:sendExcuteStage(self._stageId, self._nextWaveId)
            --     self._waitting4NextWave = true
            -- else
                -- if self._isFistDownReplay then
                --     dump("self._isFistDownReplay!")
                --     self:_firstDownEnd(self._decodeBuffer)
                -- else
                    if not self._hasEntered and decodeBuffer.battle.is_win then
                        -- 战斗结束后的剧情对话
                        G_Responder.hasBattleStory({battleFinish = true, stageId = self._stageId},
                            function()
                            end,
                            function()
                                self:_normalEnd(self._decodeBuffer)
                            end
                        )
                    else
                        dump("self._normalEnd!")
                        self:_normalEnd(self._decodeBuffer)
                    end
                -- end
            --end

        -- 处理对话事件
        elseif event == BattleLayer.BATTLE_ROUND_UPDATE then
            print("BATTLE_ROUND_UPDATE")

            local params = {...}
            local round = params[1]
            local battleLayer = params[2]

            if not self._hasEntered then
                G_Responder.hasBattleStory({round=round, stageId=stageId},
                    function()
                        --G_SubtitleService:hide()
                        --if subtitleBtn then subtitleBtn:setVisible(false) end
                        battleLayer:pauseBattle()
                        battleLayer:hideSp()
                        battleLayer:hideUI()
                        battleLayer:hideAllKnightInfo()
                    end,
                    function()
                        --G_SubtitleService:show()
                        --if subtitleBtn then subtitleBtn:setVisible(true) end
                        battleLayer:resumeBattle()
                        battleLayer:showSp()
                        battleLayer:showUI()
                        battleLayer:showAllKnightInfo()
                    end
                )
            end

        elseif event == BattleLayer.BATTLE_SOMEONE_DEAD then
            print("BATTLE_SOMEONE_DEAD")

            local params = {...}
            local identity = params[1]
            local knightId = params[2]
            local battleLayer = params[3]
            
            if identity == 2 then
                if not self._hasEntered then
                    G_Responder.hasBattleStory({monsterDead=knightId, stageId=stageId},
                        function()
                            --G_SubtitleService:hide()
                            --if subtitleBtn then subtitleBtn:setVisible(false) end
                            battleLayer:pauseBattle()
                            battleLayer:hideSp()
                            battleLayer:hideUI()
                            battleLayer:hideAllKnightInfo()
                        end,
                        function()
                            --G_SubtitleService:show()
                            --if subtitleBtn then subtitleBtn:setVisible(true) end
                            battleLayer:resumeBattle()
                            battleLayer:showSp()
                            battleLayer:showUI()
                            battleLayer:showAllKnightInfo()
                        end
                    )
                end
            end
        elseif event == BattleLayer.BATTLE_MOVE_FINISH then
            print("BATTLE_MOVE_FINISH")

            local params = {...}
            --local wave = params[1]
            local battleLayer = params[2]

            if not self._hasEntered then
                G_Responder.hasBattleStory({ stageId=stageId},
                    function()
                        --G_SubtitleService:hide()
                        --if subtitleBtn then subtitleBtn:setVisible(false) end
                        battleLayer:pauseBattle()
                        battleLayer:hideSp()
                        battleLayer:hideUI()
                        battleLayer:hideAllKnightInfo()
                    end,
                    function()
                        --G_SubtitleService:show()
                        --if subtitleBtn then subtitleBtn:setVisible(true) end
                        battleLayer:resumeBattle()
                        battleLayer:showSp()
                        battleLayer:showUI()
                        battleLayer:showAllKnightInfo()
                    end
                )
            end

        elseif event == BattleLayer.BATTLE_ENEMY_ENTER_FINISH then
            print("BATTLE_ENEMY_ENTER_FINISH")

            if not self._hasEntered then ---如果之前没有进度则可以播放boss展示

                local params = {...}
                local battleLayer = params[1]

                local function playKnightShow(knight, knightId)

                    battleLayer:pauseBattle()

                    local function eventHandler(event)

                        if event == "star" then

                            local layerColor = cc.LayerColor:create(cc.c4b(0, 0, 0, 0))
                            display.getRunningScene():addToPopupLayer(layerColor, 0, -1)

                            layerColor:runAction(cc.Sequence:create(cc.FadeTo:create(0.5, 255*0.85), cc.RemoveSelf:create()))

                        elseif event == "start" then

                            local showLayer = CommonKnightShowLayer.new(CommonKnightShowLayer.STYLE_NORMAL, knightId, 0, true, function(event, layer)
                                if event == "finish" then
                                    battleLayer:resumeBattle()
                                    layer:removeFromParent()
                                end
                            end)
                            display.getRunningScene():addToPopupLayer(showLayer)

                        end
                    end

                    local effectNode = EffectNode.new("effect_choujiang_chuxian", eventHandler)
                    display.getRunningScene():addToPopupLayer(effectNode)
                    local x, y = knight:getPosition()
                    effectNode:setPosition(x, y+60)
                    effectNode:setScale(knight:getScale())
                    effectNode:play()

                end

                -- local monsterKnights = battleLayer:getEnemyKnight()
                -- for k, knight in pairs(monsterKnights) do
                --     local knightId = knight:getCardConfig().feature
                --     if knightId ~= 0 then
                --         -- 播放武将展示特效
                --         playKnightShow(knight, knightId)
                --         break
                --     end
                -- end

            end
        end
    end)
    
    if not self._battleLayerAdded then
        self:addChild(self._battleLayer)
        self._battleLayerAdded = true
    end
    
    self._battleLayer:play(isFake)

end

function MissionBattleScene:_playBattle(data)
    self:playBattle(data.decodeBuffer, data.stageId, data.isFistDownReplay)
end

--回放
function MissionBattleScene:_replayBattle()
    self._battleLayer:replay()
end

function MissionBattleScene:_normalEnd(data)
    assert(type(data) == "table", "invalide battle end data " .. tostring(data))

    local story_stage_info = require "app.cfg.story_stage_info"
    local storyInfo = story_stage_info.get(self._stageId)
    assert(storyInfo, "Could not find the story_stage_info with id: "..tostring(self._stageId))
    
    local resultPanel = nil
    resultPanel = BattleResultLayer.new(
        G_Me.allChapterData:getCurFunID(),
        data.battle,
        function()
            -- 添加是否升级的判断
            G_Responder.isLevelUp(
                function()
                    resultPanel:removeFromParent()
                end,
                function()
                    G_ModuleDirector:popModule()
                end
            )

            -- 首充判断
            -- G_ModuleDirector:pushModule(functionId,function()
            --     --self:_openMore(false)
            --     return require("app.scenes.activity.ActivityScene").new(1,nil,ActivityConst.ACT_ID_FIRST_PAY)
            -- end)
        end
    )
    -- resultPanel = BattleSummaryLayer.new(BattleSummaryLayer.TYPE_MISSION,
    --     {
    --         isWin = data.battle.is_win,
    --         star = data.stage_star == 0 and 3 or data.stage_star,
    --         baseAwards = {
    --             -- type, value, size
    --             {type=TypeConverter.TYPE_MONEY, size=data.stage_money},
    --             {type=TypeConverter.TYPE_USER_EXPERIENCE, size=data.stage_exp},
    --         },
    --         exp = data.stage_exp,
    --         awards = data.awards,
    --         --addAwards = data.add_awards,
    --         battleParser = BattleReportHelper.parse(data.battle),
    --         missionType = storyInfo.type,
    --     }, 
    --     function()
    --         -- 添加是否升级的判断
    --         G_Responder.isLevelUp(
    --             function()
    --                 resultPanel:removeFromParent()
    --             end,
    --             function()
    --                 G_ModuleDirector:popModule()
    --                 if self.fromQteScene == true then
    --                     G_ModuleDirector:popModule()
    --                 end
    --             end
    --         )
    --     end
    -- )
    display.getRunningScene():addToPopupLayer(resultPanel)

end

-- function MissionBattleScene:_firstDownEnd(data)

--     local resultPanel = BattleSummaryLayer.new(BattleSummaryLayer.TYPE_MISSION_FIRSTDOWN, 
--         {
--             report = data.battle,
--             isWin = data.battle.is_win,
--             star = 3,
--             stageId = self._stageId,
--             battleParser = BattleReportHelper.parse(data.battle),
--         }, 
--         function()
--             G_ModuleDirector:popModule()
--         end
--     )

--     resultPanel:setButtonCallback(function(sender)
--         if sender:getName() == "Button_playback" then
--             -- 重播
--             self:_replayBattle()
--             resultPanel:removeFromParent()
--         end
--     end)

--     display.getRunningScene():addToPopupLayer(resultPanel)
-- end

function MissionBattleScene:onExit()
    uf_eventManager:removeListenerWithTarget(self)
end

return MissionBattleScene