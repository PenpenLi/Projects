local MissionBaseLayer = class("MissionBaseLayer", function ()
    return display.newLayer()
end)

----=============
----主线副本层 基类 加了背景跟滚动层
----=============

function MissionBaseLayer:ctor()
    self:enableNodeEvents()
    self._background = nil
    self._scroll = nil
end

function MissionBaseLayer:onEnter()
    self._scroll = self:_getScollerLayout()
    self._background = self:_getBackgroundNode()
    self:addChild(self._background)
    self:addChild(self._scroll)
end

function MissionBaseLayer:onExit()
    uf_eventManager:removeListenerWithTarget(self)
    self:removeAllChildren(true)
    self:disableNodeEvents()
end

function MissionBaseLayer:_getBackgroundNode()
    local isLandsCount = 10--self._scroll:getIslandsCount()
    return require("app.scenes.missionnew.missionChapter.MissionBackgroundNode").new()
end

function MissionBaseLayer:_getScollerLayout()
    return require("app.scenes.missionnew.MissionScollerLayout").new(ChapterConfigConst.NORMAL_CHAPTER)
end

return MissionBaseLayer
