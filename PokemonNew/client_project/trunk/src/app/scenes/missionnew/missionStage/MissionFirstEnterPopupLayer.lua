---==========
---首次进入章节的开场效果。
---==========
local MissionFirstEnterPopupLayer = class("MissionFirstEnterPopupLayer", function ()
	return cc.LayerColor:create(cc.c4b(0, 0, 0, 70))
end)

local MissionIndexWordLayout = require("app.scenes.missionnew.common.MissionIndexWordLayout")
local PopupBase = require("app.popup.common.PopupBase")
local SchedulerHelper = require "app.common.SchedulerHelper"
local UTF8 = require("app.common.tools.Utf8")
local UpdateNodeHelper = require "app.common.UpdateNodeHelper"

MissionFirstEnterPopupLayer.TITLE_APPRER_TIME = 0.6

------------------------
---@order 章节顺序
---@missionInfo对应章节表数据 章节标题
---@onClose 玩家点击后关闭界面的回调。
------------------------
function MissionFirstEnterPopupLayer:ctor(order, missionInfo, onClose)
   	assert(order or type(order) == "number", "invalide order value" .. tostring(order))
   	assert(missionInfo or type(missionInfo) == "table", "invalide order value" .. tostring(missionInfo))
   	assert(onClose or type(onClose) == "function", "invalide order value" .. tostring(onClose))

   	self:enableNodeEvents()

    self._titleNode = display.newNode()
    self._countKey = nil
   	self._order = order
   	self._missionInfo = missionInfo
   	self._onClose = onClose
    self._content = nil
    self._isPlayOver = false
    self._currentSound = nil
end

function MissionFirstEnterPopupLayer:onEnter()
    ---标记动画是否播放完毕
    self._isPlayOver = false

    ---一开始屏蔽点击
    self:setTouchEnabled(true)
    self:enableNodeEvents()
    self:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self:registerScriptTouchHandler(function(event)
        if event == "began" then
            return true
        elseif event == "ended" then
            if self._isPlayOver then
                self._onClose()
                self._onClose = nil
                self:removeFromParent()
            end
            return true
        end
    end)

    if self._missionInfo.id == 1001 then
        self:performWithDelay(function ( )
            --self._currentSound = G_AudioManager:playSoundById(9120)
            G_AudioManager:playSound(self._currentSound)
        end, 0.5)
    end

    self:_initUI()
    -- 申请触摸权限，因为这个时候可能有新手引导
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_TOUCH_AUTH_BEGIN, nil, false)
end

function MissionFirstEnterPopupLayer:_initUI()
    
    local bgLayer = cc.CSLoader:createNode(G_Url:getCSB("MissionMoonBoxBgLayer", "missionnew"))
    self:addChild(bgLayer, 0)
    bgLayer:setContentSize(display.width, display.height)
    ccui.Helper:doLayout(bgLayer)

    local titleText = display.newTTFLabel({
        size = 48,
        font = G_Path.getNormalFont(),
        text = G_LangScrap.get("mission_first_enter_title")})
    titleText:setColor(G_ColorsScrap.COLOR_SCENE_DESC_NORMAL)
    titleText:enableOutline(G_ColorsScrap.COLOR_SCENE_OUTLINE, 2)
    self._titleNode:addChild(titleText)
    titleText:setPosition(0, 90)

    local descStr = G_LangScrap.get("mission_chapter_disc_title", {
        num = GlobalFunc.numberToChinese(self._order) , 
        title = self._missionInfo.name
    })

    local descText = display.newTTFLabel({
        size = 32,
        font = G_Path.getNormalFont(),
        text = ""
    })
    descText:setColor(G_ColorsScrap.COLOR_SCENE_DESC_NORMAL)
    descText:enableOutline(G_ColorsScrap.COLOR_SCENE_OUTLINE, 2)
    self._titleNode:addChild(descText)
    descText:setPosition(0, 0)

    self:addChild(self._titleNode)
    self._titleNode:setPosition(display.cx, display.height * 0.6)

    local descCount = string.utf8len(descStr)
    local showWordNum = 3
    local playSpeed = 0.08
    self._countKey = SchedulerHelper.newCountdown(playSpeed * (descCount - showWordNum), playSpeed, 
        function ()
            showWordNum = showWordNum + 1
            descText:setString(UTF8.utf8sub(descStr, 1, showWordNum))
        end, 
        function ()
            SchedulerHelper.cancelCountdown(self._countKey)
            self._countKey = nil
            self:_playContinueTxtAnim()
        end)
end

function MissionFirstEnterPopupLayer:onExit()
	self:removeChild(self._content)
    G_AudioManager:stopSound(self._currentSound)
    if self._countKey ~= nil then
      SchedulerHelper.cancelCountdown(self._countKey)
    end
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_TOUCH_AUTH_END, nil, false)
end

function MissionFirstEnterPopupLayer:_playContinueTxtAnim()
    self._isPlayOver = true
    self._continueTxt = cc.CSLoader:createNode(G_Url:getCSB("CommonContinueNode", "common"))
    UpdateNodeHelper.updateCommonContinueNode(self._continueTxt, true)
    self:addChild(self._continueTxt)
    self._continueTxt:setPosition(display.cx, display.height/2 - 406)

    local fadeout=cc.FadeOut:create(0.8)
    local fadein=cc.FadeIn:create(0.3)
    local seq=cc.Sequence:create(fadeout,fadein)
    local repeatAction=cc.RepeatForever:create(seq)
    self._continueTxt:runAction(repeatAction)
end

return MissionFirstEnterPopupLayer