
-- FabaoSkillEntry

local FabaoSkillEntry = class("FabaoSkillEntry", require "app.scenes.battle.entry.TweenEntry")

function FabaoSkillEntry.create(fabaoTween, ...)
    return FabaoSkillEntry.new(string.format("battle/tween/%s.json", fabaoTween), ...)
end

function FabaoSkillEntry:ctor(...)
    FabaoSkillEntry.super.ctor(self, ...)
    self._battleField:addToSuperSpNode(self._node)
    self._node:setPosition(self._node:getParent():convertToNodeSpace(cc.p(display.cx, display.cy)))
end

function FabaoSkillEntry:createDisplayWithTweenNode(tweenNode, frameIndex, tween, node)

    local displayNode = node
    
    local fx = string.gsub("f0", "%d", frameIndex)

    if not displayNode then
        
        if tweenNode == "fabao" then

         --    local cardConfig = self._data
         --    local instrumentId = cardConfig.instrumentId
         --    local instrumentLevel = cardConfig.instrumentLevel

         --    local instrument_info = require "app.cfg.instrument_info"
         --    local instrumentInfo = instrument_info.get(instrumentId, instrumentLevel)
         --    assert(instrumentInfo, string.format("Could not find the instrument info with id %s and level %s", instrumentId, instrumentLevel))

        	-- local fabaoImg = G_Path.getBattleConfigImage("fabao", instrumentInfo.res_id..".png")
        	-- local fabaoConfig = G_Path.getBattleConfig("fabao", instrumentInfo.res_id)
        	-- fabaoConfig = decodeJsonFile(fabaoConfig)

        	-- local fabaoSprite = display.newSprite(fabaoImg)
        	-- fabaoSprite:setPosition(cc.p(fabaoConfig.x, fabaoConfig.y))

        	-- displayNode = display.newNode()
        	-- displayNode:addChild(fabaoSprite)

         --    displayNode:setCascadeOpacityEnabled(true)
         --    displayNode:setCascadeColorEnabled(true)

        elseif tweenNode == "fabao_effect" then
           	
        	local SpEntry = require "app.scenes.battle.entry.SpEntry"
            local spJson = tween[fx].start  -- 因为tweenNode引用sp的节点有点不一样，这里的start相当于在action引用sp的节点
            displayNode = SpEntry.new(spJson, self._objects, self._battleField)

        end

    end
    
    if displayNode then
        if displayNode.isEntry then
            self:addEntryToNewQueue(displayNode, displayNode.updateEntry)
            self._node:addChild(displayNode:getObject(), tween.order or 0)
        else
            self._node:addChild(displayNode, tween.order or 0)
        end
    end
    
    return displayNode

end

return FabaoSkillEntry
