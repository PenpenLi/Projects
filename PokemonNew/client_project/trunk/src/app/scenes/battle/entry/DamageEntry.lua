
-- DamageEntry

local CustomNumber = require "app.ui.number.CustomNumber"
local UpdateNodeHelper = require "app.common.UpdateNodeHelper"

local DamageEntry = class("DamageEntry", require "app.scenes.battle.entry.TweenEntry")

function DamageEntry.create(changeHp, ...)
    if type(changeHp) == "string" then
        return DamageEntry.new("battle/tween/tween_hurt.json", changeHp, ...)
    end
    if changeHp > 0 then
        return DamageEntry.new("battle/tween/tween_healing.json", changeHp, ...)
    else
        return DamageEntry.new("battle/tween/tween_hurt.json", changeHp, ...)
    end
end

function DamageEntry:ctor(damageJson, changeHp, objects, battleField, params)
    
    DamageEntry.super.ctor(self, damageJson, changeHp, objects, battleField)

    params = params or {}

    -- 暴击
    self._isCritical = params.isCritical
    -- 闪避
    self._isDodge = params.isDodge
    -- 无敌
    self._isUnmatched = params.isUnmatched
    -- 超级伤害
    self._isSuperDamage = params.isSuperDamage
    -- 反弹
    self._isRebound = params.isRebound
    -- 吸血
    self._isAbsort = params.isAbsort
    -- 格挡
    self._isGuard = params.isGuard
    -- 加减血
    self._stype = params.stype
    -- 削弱，QTE专用
    -- self._isXueruo = params.isXueruo

    self._battleField:addToDamageSpNode(self._node, objects:getLocation(), objects:getIdentity())
    self._node:setPosition(self._node:getParent():convertToNodeSpace(self._objects:convertToWorldSpaceAR(cc.p(0, 230))))

end

function DamageEntry:createDisplayWithTweenNode(tweenNode, frameIndex, tween, node)
    
    local displayNode = node
    
    if not displayNode then
        if tweenNode == "txt" then

            local damage = math.abs(self._data)
            local victim = self._objects

            local stype = self._stype or (self._data > 0 and 2 or 1)

            if self._isUnmatched then
                displayNode = display.newSprite(G_Url:getText_battle("biyou"))
            elseif self._isDodge then
                displayNode = display.newSprite(G_Url:getText_battle("shanbi"))
            else
                local fnt = "num_battle_hit"
                -- stype == 1表示扣血，2表示加血
                if stype == 2 then
                    fnt = "num_battle_heal"
                elseif self._isCritical or self._isSuperDamage then
                    fnt = "num_battle_crit"
                end
                
                -- 这里如果是0就显示0，避免显示不一致掩盖错误原因
                damage = damage ~= 0 and (stype == 1 and damage * -1 or damage) or 0

                if self._isCritical or self._isRebound or self._isAbsort or self._isGuard then

                    displayNode = display.newNode()
                    local number = CustomNumber.create(fnt, damage)

                    local showLIst = {}

                    local checkList = {self._isCritical,self._isRebound,self._isAbsort,self._isGuard}
                    local nameList = {"baoji","fantan","xixue","gedang","xueruo_1percent"}
                    local scaleNode = display.newNode()
                    scaleNode:setScale(0.6)
                    for i=1,5 do
                        if checkList[i] then
                            local descText = nameList[i]
                            local showDesc = display.newSprite(G_Url:getText_battle(descText))
                            scaleNode:addChild(showDesc)
                            table.insert(showLIst,showDesc)
                        end
                    end
                    scaleNode:addChild(number)
                    displayNode:addChild(scaleNode)
                    table.insert(showLIst,number)
                    UpdateNodeHelper.updateNodeAlign(showLIst, UpdateNodeHelper.ALIGN_CENTER)
                    -- local descText = (self._isCritical and "baoji") or 
                    --                 (self._isRebound and "fantan") or
                    --                 (self._isAbsort and "xixue") or
                    --                 (self._isGuard and "gedang") or
                    --                 (self._isXueruo and "xueruo_1percent")

                    -- local critical = display.newSprite(G_Url:getText_battle(descText))

                    -- local scaleNode = display.newNode()
                    -- scaleNode:setScale(0.6)

                    -- scaleNode:addChild(number)
                    -- scaleNode:addChild(critical)
                    -- displayNode:addChild(scaleNode)

                    -- UpdateNodeHelper.updateNodeAlign({critical, number}, UpdateNodeHelper.ALIGN_CENTER)
                -- elseif self._isXueruo then --QTE弹出削弱提示
                --     displayNode = display.newNode()

                --     local descText = "xueruo_1percent"

                --     local critical = display.newSprite(G_Url:getText_battle(descText))
                --     displayNode:addChild(critical)

                --     UpdateNodeHelper.updateNodeAlign({critical}, UpdateNodeHelper.ALIGN_CENTER)
                else
                    displayNode = CustomNumber.create(fnt, damage)
                end

                local curHPAmount = victim:getHPAmount()
                local totalHPAmount = victim:getTotalHPAmount()
                local curDamage = tonumber(damage)

                -- 加血
                if stype == 2 then
                    curDamage = math.min(totalHPAmount - curHPAmount, math.abs(curDamage))
                else
                    curDamage = math.min(curHPAmount, math.abs(curDamage))
                end

                curDamage = curDamage * (stype == 1 and -1 or 1)

                if not self._isRebound then
                    victim:changeHp(curDamage)
                end
                
                -- 冒血通知
                self._battleField:dispatchEvent(
                    self._battleField.BATTLE_DAMAGE_UPDATE,
                    victim:getIdentity(),
                    victim:getLocation(),
                    curDamage
                )

            end
            
        end

        displayNode:setCascadeOpacityEnabled(true)
        displayNode:setCascadeColorEnabled(true)
    end
     
    if displayNode then
        self._node:addChild(displayNode, tween.order or 0)
    end
    
    return displayNode
    
end

return DamageEntry
