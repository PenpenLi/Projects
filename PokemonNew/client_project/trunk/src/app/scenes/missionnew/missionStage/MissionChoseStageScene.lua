local MissionChoseStageScene=class("MissionChoseStageScene",function()
    return display.newScene("MissionChoseStageScene")
end)

local Responder = require "app.responder.Responder"
local ChapterConfigConst = require("app.const.ChapterConfigConst")
----=====
----进入选关场景
----@initData 里面有两个参数  missionId选关的章节ID, 
----stageId 指定跳转的关卡ID （可选）
----isGuideJump 是否是新手引导下的跳转（可选）
----needNum 物品需求下的跳转，会传所需的物品数量（如果是0则表示没有需求）
----type 所需求物品的类型
----value 所需求物品的ID
----====
function MissionChoseStageScene:ctor(initData)
    dump(initData)
    dump("MissionChoseStageScene:ctor(initData)!!!!!!!!!!!!!!!!!!!")
    assert(type(initData) == "table", "invalide initData" .. tostring(initData))
    self._missionId= initData.missionId
    self._stageId = initData.stageId
    self._index = G_Me.allChapterData:getIndexByChapterID(self._missionId)--initData.index
    self._isGuideJump = initData.isGuideJump ~= nil and true or false
    self._isGetWayJump = initData.isGetWayJump ~= nil and true or false
    self._missionData = nil
    self._chooseLayer = nil
    self._popupWindow = nil
    self._hud = nil
    self._popFight = initData.popFight or nil

    self:enableNodeEvents()
    self:addtUserBattleListener()--添加全局的事件侦听
    

    local chapterInfo = require("app.cfg.story_chapter_info").get(self._missionId)
    self._chapterType = chapterInfo.type
    G_Me.allChapterData:setLastChapterIndex(chapterInfo.type, self._index)
    
    -- ---如果是因为获取道具跳转过来的，则缓存要获取的道具信息
    -- if initData.needNum ~= nil and initData.needNum > 0 then
    --     local curChapterData = G_Me.allChapterData:getCurChapterData()  
    --     curChapterData:setNeedPropCache({
    --         type = initData.type,
    --         value = initData.value,
    --         needNum = initData.needNum,
    --     })
    -- end
end

function MissionChoseStageScene:onEnter()
    print("MissionChoseStageScene:onEnter")
    print("self._stageId", self._stageId)
    self:addChatFloatNode()
    ---获取关于这一章节的关卡数据
    self._missionData = G_Me.allChapterData:getChapterDataById(self._missionId)

    --
    G_widgets:getMainMenu():setVisible(false)
    --G_widgets:getTopBar():setVisible(false)

    --背景
    local strBackground = tostring(self._missionData:getCfgInfo().background)
    
    --local missionSceneImages = require("app.scenes.missionnew.mapcfg."..strBackground)
    --先用临时的
    --missionSceneImages = require "app.scenes.missionnew.missionBgCfg.Main"

    -- local mapConfig = decodeJsonFile(G_Url:getMapConfig("map_1"))
    -- assert(mapConfig, "invalide mapcfg " .. tostring(strBackground))

    --选择管理界面
    dump(self._missionId)
    self._chooseLayer = require("app.scenes.missionnew.missionStage.MissionChoseStageLayer").new(self._missionId, self._stageId, self._isGuideJump,self._index,self._isGetWayJump,self._popFight)
    self:addChild(self._chooseLayer)
    self._popFight = nil

    --ui界面
    self._hud = require("app.scenes.missionnew.missionStage.MissionStageGUILayout").new(self._missionId)
    self:addChild(self._hud)

    self._hud:addListeners()
    -- --有新的群妖 --有你麻痹，LeiCode，目前关闭这个功能。
    -- G_Me.spookyData:checkBossAppeared()
    
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_SHOW_UI, self._showUI, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_HIDE_UI, self._hideUI, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_PLAY_BATTLE, self._playBattle, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_POP_FASET_EXCUTE, self._popFastPanel, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_REMOVE_FASET_EXCUTE, self._removeFastPanel, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVNET_USE_ITEM_SUCCESS, self._useItemSuccess,self) --使用成功的事件监听

    local barMap = {
        [ChapterConfigConst.NORMAL_CHAPTER] = "topbarLevel1",
        [ChapterConfigConst.ELITE_CHAPTER] = "topbarLevel3Block",
        [ChapterConfigConst.NIGHTMARE_CHAPTER] = "topbarLevel1",
    }
    
    self:regeditWidgets(barMap[self._chapterType])

    self._chooseLayer:setVisible(true)
    self._hud:setVisible(true)

    local chapterHasEntered = self._missionData:getHasEnterd() --章节是否有进度
    ---和服务端通信记录章节已经进入
    if not chapterHasEntered then
        G_HandlersManager.chapterHandler:sendFirstEnterChapter(self._missionId)
        G_Me.allChapterData:setChapterHasEnter(self._missionId)
    end
    
    G_AudioManager:playBGM(G_AudioConst.BGM_CHAPTER_STAGE)

    if self._battleDataTemp and self._battleDataTemp.display_result and self._battleDataTemp.display_result.awards then
        local awards = self._battleDataTemp.display_result.awards
        for i=1,#awards do
            if G_TypeConverter.TYPE_ITEM == awards[i].type and awards[i].value == 951 then
                self:_checkSelectFromFour()
                self._battleDataTemp = nil
                break;
            end
        end
    end

    -- uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,100)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,200)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,402)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,500)
    --uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,600)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,602)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,801)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1002)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1302)

    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,700)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1100)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1200)

    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1753)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1755)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1775)

    if self._missionId == 1002 then
        uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1400)
    end
end

--使用成功时的反馈飘字
function MissionChoseStageScene:_useItemSuccess(msg)
    if type(msg) ~= "table" then return end
    G_Popup.awardTips(msg.awards)
end

--检查武将四选一
function MissionChoseStageScene:_checkSelectFromFour( ... )
    local ItemInfo = require "app.cfg.item_info" 
    self._dataList = G_Me.propsData:getItemsData()
    for i=1,#self._dataList do
        local itemId = self._dataList[i].id
        local itemInfo = ItemInfo.get(itemId)
        if itemId == 951 and not G_GuideManager:AOverB(G_Me.userData.guideId,1405) then--四大美女大礼包 --新手引导超过则不引导
            --tempcode
            G_Popup.newSelectRewardPopup(
            function ( index )
                G_HandlersManager.PropsHandler:sendUseItem(itemId, 1, itemInfo.item_value, index)
            end,
            nil,itemInfo.item_value,false)
        end
    end
end

function MissionChoseStageScene:onExit()
    --G_widgets:getMainMenu():setVisible(true)
    G_widgets:getTopBar():setVisible(true)
    self._chooseLayer:setVisible(false)
    self._hud:removeListenrs()
    self:_removeFastPanel()
    uf_eventManager:removeListenerWithTarget(self)
    self._stageId = nil
    self:removeChild(self._chooseLayer)
    self:removeChild(self._hud)
    self._missionData = nil
    self._chooseLayer = nil
    self._hud = nil
    self._stageId = nil
end

function MissionChoseStageScene:onCleanup()
    local curChapterData = G_Me.allChapterData:getCurChapterData()  
    if curChapterData then
        curChapterData:clearNeedPropCache()
        G_Me.allChapterData:getRecordStageStatus(self._missionId) --特殊情况直接跳出场景的，需要清除战斗情况
        curChapterData:clearExitIndex()
    end
end

function MissionChoseStageScene:_playBattle(data)
    self._battleDataTemp = data.decodeBuffer.battle--用于四大美女的检测
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAPTER_CLOSE_CHALLENGE_PANEL)

    ---首杀播放
    if data.isFistDownReplay then
         G_ModuleDirector:pushModuleWithAni(nil, function()
            self._battleScene = require("app.scenes.missionnew.missionStage.MissionBattleScene").new()
            self._battleScene:playBattle(data.decodeBuffer, data.stageId, 
                data.isFistDownReplay, true, true)
            return self._battleScene
        end)

        return
    end

     ----调用战斗场景，开始播放战斗
    --local chapterHasEntered = self._missionData:getHasEnterd() --章节是否有进度
    local stageHasEntered = G_Me.allChapterData:getStageHasEnteredById(data.stageId) --关卡是否有进度
    if not stageHasEntered then --记录缓存
        G_Me.allChapterData:setStageHasEnterdById(data.stageId)
    end

    local battleCall = function ( )
        G_ModuleDirector:pushBattleModuleWithAni(nil, function()
            self._battleScene = require("app.scenes.missionnew.missionStage.MissionBattleScene").new()
            self._battleScene:playBattle(data.decodeBuffer, data.stageId, 
                data.isFistDownReplay, stageHasEntered, data.oldStageThreeStar, data.isFake)
            return self._battleScene
        end, require("app.cfg.story_stage_info").get(data.stageId).in_res)
    end
    
    -- 发送新手引导推进消息，这里已经收到战斗消息
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,101)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1401)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1754)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1776)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,403)
    --uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,601)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,603)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1003)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1303)

    ---关卡进入过
    if stageHasEntered then
        battleCall()
    else
        Responder.hasStory(data.stageId, handler(self, self._hideUI) , battleCall)
    end
    ---和服务端通信记录章节已经进入
    if not chapterHasEntered then
        G_HandlersManager.chapterHandler:sendFirstEnterChapter(self._missionId)
        G_Me.allChapterData:setChapterHasEnter(self._missionId)
    end
end

function MissionChoseStageScene:_popFastPanel(data)
    local popup = require("app.popup.Popup")
    popup.newPopup(function() 
        self._popupWindow = require("app.scenes.missionnew.missionStage.fast.MissionFastExecutePopupLayout").new(data.id, data.times, data.index, data.chapterType,data.maxStar)
        return self._popupWindow
    end)
end

function MissionChoseStageScene:_removeFastPanel()
    print(":::::::::::::::::::::_removeFastPanel",self._popupWindow)
    if self._popupWindow ~= nil then
        self._popupWindow:removeFromParent(true)
        self._popupWindow = nil
    end
end

function MissionChoseStageScene:_hideUI()
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAPTER_HIDE_HERO, nil, false, nil)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAPTER_HIDE_BOX_AND_RANK, nil, false, nil)
    G_widgets:getMainMenu():setVisible(false)
    self._hud:setVisible(false)
    G_widgets:getTopBar():setVisible(false)
end

function MissionChoseStageScene:_showUI()
    G_widgets:getMainMenu():setVisible(true)
    self._hud:setVisible(true)
    G_widgets:getTopBar():setVisible(true)
end

return MissionChoseStageScene