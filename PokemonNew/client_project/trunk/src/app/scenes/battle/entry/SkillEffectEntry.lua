
-- SkillEffectEntry

-- 技能环境特效

local SkillEffectEntry = class("SkillEffectEntry", require "app.scenes.battle.entry.TweenEntry")

function SkillEffectEntry.create(tweenJsonName, ...)
    return SkillEffectEntry.new("battle/tween/"..tweenJsonName..".json", ...)
end

function SkillEffectEntry:ctor(...)
    SkillEffectEntry.super.ctor(self, ...)
    self._battleField:addToFlickerNode(self._node)
    self._node:setPosition(display.cx, display.cy)
end

function SkillEffectEntry:initEntry()

    SkillEffectEntry.super.initEntry(self)

    self:insertEntryToQueueAtTop(nil, function()

        local battleField = self._battleField
        local attackers = self._objects[1]
        local victims = self._objects[2]

        local attackerIdentity = nil

        local knightNode = display.newNode()
        self._node:addChild(knightNode, 100)
        knightNode:setPosition(-display.cx, -display.cy)

        -- 移动攻击者
        for k, attacker in pairs(attackers) do
            attackerIdentity = attackerIdentity or attacker:getIdentity()
            attacker:retain()
            local order = attacker:getLocalZOrder()
            attacker:removeFromParent(false)
            knightNode:addChild(attacker, order)
            attacker:release()
        end

        -- 受害者
        for i=1, #victims do
            local victim = victims[i]
            if victim.getIdentity and victim:getIdentity() ~= attackerIdentity then
                victim:retain()
                local order = victim:getLocalZOrder()
                victim:removeFromParent(false)
                knightNode:addChild(victim, order)
                victim:release()
            end
        end

        return true

    end)

end

function SkillEffectEntry:createDisplayWithTweenNode(tweenNode, frameIndex, tween, node)
    
    local displayNode = node
    
    if not displayNode then
        if tweenNode == "skill_effect" then

            displayNode = cc.LayerColor:create(cc.c4b(0, 0, 0, 0), display.width*2, display.height*2)
            displayNode:setIgnoreAnchorPointForPosition(false)

            displayNode:setCascadeOpacityEnabled(true)
            displayNode:setCascadeColorEnabled(true)
        end
    end
    
    if displayNode then
        self._node:addChild(displayNode, tween.order or 0)
    end
    
    return displayNode
end

function SkillEffectEntry:destroyEntry()

    local battleField = self._battleField
    local attackers = self._objects[1]
    local victims = self._objects[2]

    local attackerIdentity = nil

    -- 移动攻击者
    for k, attacker in pairs(attackers) do
        attackerIdentity = attackerIdentity or attacker:getIdentity()
        attacker:retain()
        local order = attacker:getLocalZOrder()
        attacker:removeFromParent(false)
        battleField:addToCardNode(attacker, order)
        attacker:release()
    end

    -- 受害者
    for i=1, #victims do
        local victim = victims[i]
        if victim.getIdentity and victim:getIdentity() ~= attackerIdentity then
            victim:retain()
            local order = victim:getLocalZOrder()
            victim:removeFromParent(false)
            battleField:addToCardNode(victim, order)
            victim:release()
        end
    end

    SkillEffectEntry.super.destroyEntry(self)

end

return SkillEffectEntry
