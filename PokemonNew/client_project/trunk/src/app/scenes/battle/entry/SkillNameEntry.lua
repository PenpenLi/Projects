
-- SkillNameEntry

local UpdateNodeHelper = require "app.common.UpdateNodeHelper"

local SkillNameEntry = class("SkillNameEntry", require "app.scenes.battle.entry.TweenEntry")

function SkillNameEntry.create(...)
    return SkillNameEntry.new("battle/tween/tween_2group_skillname.json", ...)
end

function SkillNameEntry:ctor(tweenJson, data, objects, battleField, eventHandler, playInfo)

    SkillNameEntry.super.ctor(self, tweenJson, data, objects, battleField, eventHandler)

    self._playInfo = playInfo

    self._battleField:addToSuperSpNode(self._node, 10)
    self._node:setPosition(self._node:getParent():convertToNodeSpace(cc.p(display.cx, display.cy)))

end

function SkillNameEntry:createDisplayWithTweenNode(tweenNode, frameIndex, tween, node)
    
    local attacks = self._data
    local fx = string.gsub("f0", "%d", frameIndex)
    
    local displayNode = node
    
    if not displayNode then

        -- 技能名称
        if tweenNode == "skill_name" then

            local playInfo = self._playInfo
            local txtId = playInfo.txt

            displayNode = display.newNode()
            displayNode:setCascadeColorEnabled(true)
            displayNode:setCascadeOpacityEnabled(true)

            -- 法宝·
            local fabao = display.newSprite(G_Url:getText_skill(90000))
            fabao:setCascadeOpacityEnabled(true)
            fabao:setCascadeColorEnabled(true)
            displayNode:addChild(fabao)

            -- 技能名
            local node = display.newNode()
            node:setCascadeOpacityEnabled(true)
            node:setCascadeColorEnabled(true)
            node:setAnchorPoint(cc.p(0.5, 0.5))
            displayNode:addChild(node)

            local skill = display.newSprite(G_Url:getText_skill(txtId))
            skill:setCascadeOpacityEnabled(true)
            skill:setCascadeColorEnabled(true)
            node:addChild(skill)

            local scaleFactor = 0.8
            skill:setScale(scaleFactor)

            local size = skill:getContentSize()
            size.width, size.height = size.width*scaleFactor, size.height*scaleFactor

            skill:setPosition(size.width/2, size.height/2)
            node:setContentSize(size)
            
            UpdateNodeHelper.updateNodeAlign({fabao, node}, UpdateNodeHelper.ALIGN_CENTER)

        elseif tweenNode == "skill_name_bg" then
            
            displayNode = display.newSprite(G_Url:getUI_battle("txt_battle_attack_bg"))
            displayNode:setCascadeOpacityEnabled(true)
            displayNode:setCascadeColorEnabled(true)

        end
        
    end
    
    assert(displayNode, "Unknown tweenNode: "..tweenNode)
    
    if displayNode then
        
        local parent = self._node
        parent:addChild(displayNode, tween.order or 0)
    end
    
    return displayNode

end

return SkillNameEntry
