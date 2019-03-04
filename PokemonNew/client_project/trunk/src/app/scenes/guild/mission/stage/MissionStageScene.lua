--
-- Author: Your Name
-- Date: 2018-04-23 20:29:08
--
local MissionStageScene=class("MissionStageScene",function()
    return display.newScene("MissionStageScene")
end)

local Responder = require "app.responder.Responder"
local ChapterConfigConst = require("app.const.ChapterConfigConst")
----=====
----进入选关场景
----@initData 里面有两个参数 

----====
function MissionStageScene:ctor(initData)
    dump("MissionStageScene:ctor(initData)!!!!!!!!!!!!!!!!!!!")
    assert(type(initData) == "table", "invalide initData" .. tostring(initData))
    self._chapterId= initData.chapterId
    
    self._hud = nil
    
    self:enableNodeEvents()
    self:addtUserBattleListener()--添加全局的事件侦听
end

function MissionStageScene:onEnter()
    print("MissionStageScene:onEnter")
    --uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUILD_GET_CHAPTER_LIST, self._exit, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUILD_POP_STAEG_SCENE, self._exit, self)

    self:addChatFloatNode()
    self:regeditWidgets("mainmenu","topbarLevel2")

    self._stageLayer = require("app.scenes.guild.mission.stage.MissionStageLayer").new(self._chapterId,1)
    self:addChild(self._stageLayer)

    --ui界面
    self._hud = require("app.scenes.guild.mission.stage.MissionStageGUILayout").new(self._chapterId,2)
    self:addChild(self._hud)
    self._hud:addListeners()

    --request data
    if G_Me.guildMissionData:isExpired() then
        G_HandlersManager.guildHandler:sendGetChapterList()
    end
end

function MissionStageScene:_recvData( ... )
    self._stageLayer:updateView()
end

function MissionStageScene:_exit( ... )
    G_ModuleDirector:popModule()
end

function MissionStageScene:onExit()
    uf_eventManager:removeListenerWithTarget(self)
    self._hud:removeListenrs()
    self:removeChild(self._stageLayer)
    self:removeChild(self._hud)
    self._stageLayer = nil
    self._hud = nil
end

return MissionStageScene