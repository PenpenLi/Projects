--
-- Author: wyx
-- Date: 2018-04-25 14:10:24
--
local MissionBaseGUILayout = require("app.scenes.guild.mission.common.MissionBaseGUILayout")
local MissionStageGUILayout = class("MissionStageGUILayout",MissionBaseGUILayout)
local MissionTimeLimite = require("app.scenes.missionnew.common.MissionTimeLimite")

local ChapterConfigConst = require("app.const.ChapterConfigConst")
---===================
---关卡界面的GUI
---@chapterId 章节ID
---===================
function MissionStageGUILayout:ctor(chapterId)
    assert(type(chapterId) == "number", "invalide chapterId " .. tostring(chapterId))
    MissionStageGUILayout.super.ctor(self,chapterId)

    --G_Me.allChapterData:setStageLastEnterdById(self._missionId)
	self:enableNodeEvents()
    self._inited = false
end

function MissionStageGUILayout:onEnter()
    print("MissionStageGUILayout:onEnter")
    MissionStageGUILayout.super.onEnter(self)

end

-- function MissionStageGUILayout:addListeners()
--     --uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUILD_RECV_BUG_COUNT, self._updateData, self)
--     --uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_HIDE_BOX_AND_RANK, self._hideBoxAndRank, self)
-- end

-- function MissionStageGUILayout:removeListenrs()
--     uf_eventManager:removeListenerWithTarget(self)
-- end

function MissionStageGUILayout:showOtherUIxx()
    -- times
    self._timesNode = cc.CSLoader:createNode(G_Url:getCSB("MissionStageTimes", "guild/mission"))
    self:addChild(self._timesNode)
    self._timesNode:setPosition(display.width + 300,display.height-200)

    local actionBot = cc.MoveTo:create(0.3, cc.p(display.width, display.height-200))
    actionBot = cc.Sequence:create(cc.DelayTime:create(0.3),cc.EaseBackOut:create(actionBot))
    self._timesNode:runAction(actionBot)

    self._helpBtn = cc.CSLoader:createNode(G_Url:getCSB("commonHelpNode", "common"))
    self._helpBtn:align(display.RIGHT_TOP , display.width - 165, display.height - 89)
    self:addChild(self._helpBtn, 100)

    self._helpBtn:updateButton("Button_help",function ()
        G_Popup.newHelpPopup(G_FunctionConst.FUNC_UNION_FUBEN)
    end)

    self:freshTimes()
end

-- function MissionStageGUILayout:_updateData()
--     self:_freshTimes()
-- end

-- function MissionStageGUILayout:_freshTimes()
--     self._normalCount = G_Me.guildMissionData:getNormalCount()
--     self._bossCount = G_Me.guildMissionData:getBossCount()

--     self._timesNode:updateLabel("Text_times_elite", {
--     	text = tonumber(self._normalCount),
--     	textColor = G_Colors.getColor(11),
--     	})
--    	self._timesNode:updateLabel("Text_times_boss", {
--     	text = tonumber(self._bossCount),
--     	textColor = G_Colors.getColor(11),
--     	})

--    	self._timesNode:updateButton("Button_add_elite",function ( ... )
--    		self._onBuyCount(1)
--    	end)
--    	self._timesNode:updateButton("Button_add_boss",function ( ... )
--    		self._onBuyCount(2)
--    	end)
-- end

-- function MissionStageGUILayout:_onBuyCount(type)
--     local ownNum,boughtNum,funId = 0,0,0
--     if type == 1 then
--         boughtNum = G_Me.guildMissionData:getNormalBoughtCount()
--         ownNum = self._normalCount
--         funId = G_VipConst.FUNC_TYPE_GUILD_MISSION_NORMAL
--     else
--         boughtNum = G_Me.guildMissionData:getBossBoughtCount()
--         ownNum = self._bossCount
--         funId = G_VipConst.FUNC_TYPE_GUILD_MISSION_BOSS
--     end

--     local hasReach = G_Responder.vipTimeOutCheck(
--         funId,
--         {usedTimes = boughtNum,tips = ""}
--     )

--     if hasReach then
--         return
--     end

--     G_Popup.newBuyChallengesPopup(funId,ownNum,boughtNum,function(buyNum)
--         G_HandlersManager.guildHandler:sendBuyCount(type,buyNum)
--     end)
-- end

function MissionStageGUILayout:_hideBoxAndRank()
    --dump(self._inited)
    if not self._inited then
        return
    end
    self._btnRank:setVisible(false)
    self._tray:setVisible(false)
    self._label:setVisible(false)
    self._labelBg:setVisible(false)
    self._buttonBack:setVisible(false)
    self._totalStarNode:setVisible(false)
end

return MissionStageGUILayout