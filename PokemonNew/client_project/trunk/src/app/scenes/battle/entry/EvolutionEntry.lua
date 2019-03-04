-- EvolutionEntry

local ActionFactory = require "app.common.action.Action"

local EvolutionEntry = class("EvolutionEntry", require "app.scenes.battle.entry.Entry")

function EvolutionEntry:initEntry()

    EvolutionEntry.super.initEntry(self)

    self:addEntryToQueue(self, self.update)

end

function EvolutionEntry:update(frameIndex)

    if self._fadeTo then
        if self._action then
            self._action:release()
            self._action = nil
        end
    end

    if not self._displayNode then

        local bgId = self._data

        local backgroundNode = display.newNode()
        backgroundNode:setCascadeColorEnabled(true)
        backgroundNode:setCascadeOpacityEnabled(true)
        self._battleField:addToComboNode(backgroundNode, -1)
        backgroundNode:setPosition(cc.p(display.cx, display.cy))

        local background = display.newSprite("battle/background/"..bgId..".jpg")
        backgroundNode:addChild(background)
        -- jpg图像被缩小到75%
        background:setScale(1/0.75)

        -- 兼容原来老的png，未来会去掉
        if string.find(bgId, ".png") then
            background:setScale(1)
        end

        self._displayNode = backgroundNode
        
        local size = background:getContentSize()
        self._displayNode:setScale(math.max(1, math.max(display.width / size.width, display.height / size.height)))

        self._displayNode:retain()

    end

    if not self._action then
        self._displayNode:setOpacity(self._fadeStart)
        self._action = ActionFactory.newFadeTo(self._totalFrame, self._fadeTo)
        self._action:startWithTarget(self._displayNode)

        self._fadeTo = nil
    end

    self._action:step(1)

    return self._action:isDone()

end

function EvolutionEntry:destroyEntry()

    EvolutionEntry.super.destroyEntry(self)

    if self._displayNode then
        
        if self._displayNode:getParent() then
            self._displayNode:removeFromParent()
        end

        self._displayNode:release()
        self._displayNode = nil
    end

end

function EvolutionEntry:fadeIn()

    self._totalFrame = 8
    self._fadeStart = 0
    self._fadeTo = 255

end

function EvolutionEntry:fadeOut()

    self._totalFrame = 8
    self._fadeStart = 255
    self._fadeTo = 0

end

return EvolutionEntry

