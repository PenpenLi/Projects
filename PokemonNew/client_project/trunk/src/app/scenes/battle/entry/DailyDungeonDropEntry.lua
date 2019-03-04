
-- DailyDungeonDropEntry

local DailyDungeonDropEntry = class("DailyDungeonDropEntry", require "app.scenes.battle.entry.TweenEntry")

function DailyDungeonDropEntry.create(...)
    local tweenName = string.format("battle/tween/tween_pantao_taozi_%s.json", math.random(1, 3))
    return DailyDungeonDropEntry.new(tweenName, ...)
end

function DailyDungeonDropEntry:ctor(tweenJson, data, objects, battleField, eventHandler, size)

    DailyDungeonDropEntry.super.ctor(self, tweenJson, data, objects, battleField, eventHandler)

    -- 随机一个椭圆位置
    local a, b = math.random(200, size.width/2), math.random(200, size.height/2)
    local angle = math.rad(math.random(-190, 10))
    local position = cc.p(a/2*math.cos(angle), b/2*math.sin(angle))

    objects:addToBodyFore(self._node, -position.y)
    self._node:setPosition(position)

end

function DailyDungeonDropEntry:createDisplayWithTweenNode(tweenNode, frameIndex, tween, node)
    
    local displayNode = node
    local dropId = self._data

    if not displayNode then

        if tweenNode == "pantao" then
            displayNode = display.newSprite(string.format("newui/mission/bg_mission_daily/%s.png", dropId))
        end

        displayNode:setCascadeOpacityEnabled(true)
        displayNode:setCascadeColorEnabled(true)
    end
    
    assert(displayNode, "Invalid node named: "..tostring(tweenNode))

    if displayNode then
        self._node:addChild(displayNode, tween.order or 0)
    end
    
    return displayNode
end

return DailyDungeonDropEntry
