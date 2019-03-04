
-- CounterAttackEntry

local Entry = require "app.scenes.battle.entry.Entry"
local MoveEntry = require "app.scenes.battle.entry.MoveEntry"
local EntryWrapper = require "app.scenes.battle.entry.EntryWrapper"
local ActionEntry = require "app.scenes.battle.entry.ActionEntry"
local DamageEntry = require "app.scenes.battle.entry.DamageEntry"
local BattleFieldConst = require "app.scenes.battle.BattleFieldConst"

local fileUtils = cc.FileUtils:getInstance()

local resource_manager = require "app.cfg.resource_manage"


local CounterAttackEntry = class("CounterAttackEntry", require "app.scenes.battle.entry.AttackEntry")

function CounterAttackEntry:initEntry()

	CounterAttackEntry.super.initEntry(self)

	local attacksData = self._data--攻击的战报数据
    local knights = self._objects
    local battleField = self._battleField

    -- 攻击者数组
    local attackers = {}
    self._attackers = attackers

    -- 受害者数组
    local victims = {}
    self._victims = victims

    -- 受害详细信息数组
    local victimInfos = {}
    self._victimInfos = victimInfos

    -- 攻击相关信息初始化
    for i=1, #attacksData do

        local attacks = attacksData[i]

        -- 多个反击攻击者
        local attacker = knights[attacks.attack_pos.order][tostring(attacks.attack_pos.pos)]
        assert(attacker, string.format("Invalid counter attacker with order: %s and pos: %s", attacks.attack_pos.order, attacks.attack_pos.pos))

        attackers[#attackers+1] = attacker
        self._attackers.release_knight = self._attackers.release_knight or attacker

        -- 受害者应该是同一人
        local order, pos
        for i=1, #attacks.attack_infos do
            
            local member = attacks.attack_infos[i].defense_member
            victims[1] = victims[1] or knights[member.order][tostring(member.pos)]

            self._victimInfos[member.pos] = attacks.attack_infos[i]
        end
    end

    -- 开始走战报

    -- 保存旧order
    self._oldOrder = self._oldOrder or {}
    for k, attacker in pairs(attackers) do
        self._oldOrder[attacker] = attacker:getLocalZOrder()
    end

    -- 可能是多人攻击，所以准备一个entrySet
    local entrySet = Entry.new()
    self:addEntryToQueue(entrySet, entrySet.updateEntry, nil, attackers.release_knight)

    -- 反击站位常量
    local counterAttackPos = {
        cc.p(-100, -100),
        cc.p(0, -100),
        cc.p(100, -100)
    }

    -- 进攻开始
    for i=1, #attackers do

        local attacker = attackers[i]

        -- 每一个人的攻击有时间间隔，先插入一个时间间隔
        entrySet:addEntryToQueue(nil, EntryWrapper.entryDelay((i-1)*5), nil, attacker)

        -- 因为反击走的动作和位置都是固定的，所以这里直接就取常量值了

        -- 先隐藏血条等
        entrySet:addOnceEntryToQueue(nil, function()
            attacker:setHPVisible(false)
            attacker:setNameVisible(false)
            attacker:setOrderVisible(false)
            attacker:setStarVisible(false)
            attacker:setAngerVisible(false)
            attacker:setBreathAniEnabled(false)
            return true
        end, nil, attacker)

        -- 同一时间最多3个位置
        if i <= 3 then

            -- 位置固定为常量值
            local dstPosition = cc.pAdd(cc.p(self._victims[1]:getPosition()), counterAttackPos[i])

            local movePosition = cc.pSub(dstPosition, cc.p(attacker:getPosition()))
            if attacker:getIdentity() == 2 then
                movePosition = cc.pMul(movePosition, -1)
            end

            -- 添加移动entry
            if movePosition then
                local moveEntry = MoveEntry.new(movePosition, attacker, battleField)
                entrySet:addEntryToQueue(moveEntry, moveEntry.updateEntry, nil, attacker)
            end

            -- 攻击的时候隐藏阴影
            entrySet:addOnceEntryToQueue(nil, function()
                attacker:setShadowVisible(false)
                return true
            end, nil, attacker)

            local attack_action_id = BattleFieldConst.action["COUNTER_"..i]
            if self._attackers.release_knight:getIdentity() == 2 then
                if fileUtils:isFileExist(fileUtils:fullPathForFilename(BattleFieldConst.action["COUNTER_"..i.."_R"])) then
                    attack_action_id = BattleFieldConst.action["COUNTER_"..i.."_R"]
                end
            end

            -- 过滤一下消息
            local attackEntry = ActionEntry.new(attack_action_id, attacker, battleField, function(events, ...)

                local events = self:_splitEvents(events)
                for j=1, #events do
                    local event = events[j]
                    if event == "finish" then
                        if i == #attackers then
                            self:_onAttackerEvent(event, ...)
                        end
                    else
                        self:_onAttackerEvent(event, ...)
                    end
                end
            end)
            -- attackEntry:addEntryToNewQueue(nil, function()
            --     local attackSound = self._playInfo.start_sound ~= "0" and self._playInfo.start_sound or nil
            --     if attackSound then
            --         G_AudioManager:playSound(attackSound)
            --     end
            --     return true
            -- end)
            entrySet:addEntryToQueue(attackEntry, attackEntry.updateEntry, nil, attacker)

            -- 主攻击者开始做动作之后就可以统计一下伤害次数了
            if key == "release_knight" then
                self:_calcDamageCount(attackEntry)
            end

            -- 恢复阴影
            entrySet:addOnceEntryToQueue(nil, function()
                attacker:setShadowVisible(true)
                return true
            end, nil, attacker)

            -- 移动回来
            if movePosition then
                -- 位置是相对值，所以直接反转
                movePosition = cc.pMul(movePosition, -1)

                local moveEntry = MoveEntry.new(movePosition, attacker, battleField)
                entrySet:addEntryToQueue(moveEntry, moveEntry.updateEntry, nil, attacker)
            end

            entrySet:addOnceEntryToQueue(nil, function()
                attacker:setLocalZOrder(self._oldOrder[attacker])
                attacker:setBreathAniEnabled(true)
                attacker:setHPVisible(true)
                attacker:setOrderVisible(true)
                attacker:setNameVisible(true)
                attacker:setStarVisible(true)
                attacker:setAngerVisible(true)
                return true
            end, nil, attacker)

        end
    end

end

function CounterAttackEntry:_onAttackerEvent(event, target, frameIndex)

    local attacks = self._data
    local knights = self._objects
    local playInfo = self._playInfo
    local battleField = self._battleField
    
    -- 事件如果为空？？则直接返回
    if not event then return end

    local events = self:_splitEvents(event)

    for i=1, #events do

        local event = events[i]

        if string.match(event, "hit") then

            local victims = self._victims
            
            -- 震屏
            if self._isSuperSkill then
                local bMatch = false
                for i=1, #attacks.attack_infos do
                    local info = attacks.attack_infos[i]
                    if info.defense_member.order ~= attacks.attack_pos.order then
                        -- 技能如果有施加在敌方的就震屏（包括供给敌方后给我方加血），否则（只给攻击方加血）就不震
                        bMatch = true
                    end
                end
                if bMatch then
                    if not self._shakeEntry then
                        self._shakeEntry = require("app.scenes.battle.entry.ShakeEntry").new(15, 0, 30, battleField:getBattleField())
                        self:addEntryToQueue(self._shakeEntry, self._shakeEntry.updateEntry, nil, "shake")
                        self._shakeEntry:retainEntry()
                    else
                        if self._shakeEntry:isDone() then
                            self._shakeEntry:initEntry()
                            self:addEntryToQueue(self._shakeEntry, self._shakeEntry.updateEntry, nil, "shake")
                        end
                    end
                end
            end

            -- 受击动画现在需要放到单独的entry当中，因为会有后续动作排在受击动画都播放完成之后
            if not self._victimEntrySet then
                self._victimEntrySet = Entry.new()
                self:addEntryToQueue(self._victimEntrySet, self._victimEntrySet.updateEntry, nil, "victimEntrySet")
                self._victimEntrySet:retainEntry()
            else
                if self._victimEntrySet:isDone() then
                    self._victimEntrySet:initEntry()
                    self:addEntryToQueue(self._victimEntrySet, self._victimEntrySet.updateEntry, nil, "victimEntrySet")
                end
            end

            for i=1, #victims do

                local victim = victims[i]
                victim:setBreathAniEnabled(false)
                
                if not victim.isBoss then

                    -- 受击action, 因为在一个受击action打击过程中如果又有一个打击，则需要重新开始受击动作
                    self._hitAction = self._hitAction or {}
                    -- 如果没有受击动作或者是一个超级受击动作，则创建新动作
                    if not self._hitAction[victim] then

                        local defend_action_id = BattleFieldConst.action.COUNTER_HIT
                        if victim:getIdentity() == 1 then
                            if fileUtils:isFileExist(fileUtils:fullPathForFilename(BattleFieldConst.action.COUNTER_HIT_R)) then
                                defend_action_id = BattleFieldConst.action.COUNTER_HIT_R
                            end
                        end

                        local hitEntry = ActionEntry.new(defend_action_id, victim, battleField)
                        -- hitEntry:addEntryToNewQueue(nil, function()
                        --     local hitSound = self._skillConfig.hit_sound ~= "0" and self._skillConfig.hit_sound or nil
                        --     if event == "hit_s" then
                        --         hitSound = self._skillConfig.hit_s_sound ~= "0" and self._skillConfig.hit_s_sound or hitSound
                        --     end
                        --     if hitSound then
                        --         G_AudioManager:playSound(hitSound)
                        --     end
                        --     return true
                        -- end)

                        self._victimEntrySet:addEntryToQueue(hitEntry, hitEntry.updateEntry, nil, victim)
                        hitEntry:retainEntry()

                        self._hitAction[victim] = hitEntry
                    else
                        -- 初始化引用动作
                        self._hitAction[victim]:initEntry()
                        if self._hitAction[victim]:isDone() then
                            
                            -- self._hitAction[victim]:addEntryToNewQueue(nil, function()
                            --     local hitSound = self._skillConfig.hit_sound ~= "0" and self._skillConfig.hit_sound or nil
                            --     if event == "hit_s" then
                            --         hitSound = self._skillConfig.hit_s_sound ~= "0" and self._skillConfig.hit_s_sound or hitSound
                            --     end
                            --     if hitSound then
                            --         G_AudioManager:playSound(hitSound)
                            --     end
                            --     return true
                            -- end)
                            self._victimEntrySet:addEntryToQueue(self._hitAction[victim], self._hitAction[victim].updateEntry, nil, victim)
                        end
                    end
                end
            end

        elseif string.match(event, "hurt") then
            
            local victims = self._victims

            -- 冒血
            for i=1, #victims do
                
                local victim = victims[i]
                -- hurt次数
                local hurts = self._hurtCount
                local info = self._victimInfos[victim:getLocation()]
                -- 反击不考虑加血的情况，就是扣血
                local changeHp = info.value * -1

                local tween = DamageEntry.create(changeHp, victim, battleField)
                if self._skillType == 1 then
                    tween:getObject():setScale(0.7)
                end
                battleField:addEntryToNewQueue(tween, tween.updateEntry)

            end

        elseif event == "finish" then

            -- 这里主要是攻击者的finish，表示攻击者动作做完，则表示不会再有下一次攻击动作了

            -- 受击动画现在需要放到单独的entry当中，因为会有后续动作排在受击动画都播放完成之后
            if not self._victimEntrySet then
                self._victimEntrySet = Entry.new()
                self:addEntryToQueue(self._victimEntrySet, self._victimEntrySet.updateEntry, nil, "victimEntrySet")
                self._victimEntrySet:retainEntry()
            else
                if self._victimEntrySet:isDone() then
                    self._victimEntrySet:initEntry()
                    self:addEntryToQueue(self._victimEntrySet, self._victimEntrySet.updateEntry, nil, "victimEntrySet")
                end
            end

            -- 清理受击动作引用
            if self._hitAction then
                for victim in pairs(self._hitAction) do
                    self._victimEntrySet:addOnceEntryToQueue(nil, function()
                        self._hitAction[victim]:releaseEntry()
                        self._hitAction[victim] = nil
                        return true
                    end, nil, self._shootEntrySet and self._shootEntrySet[victim] or victim)
                end
            end
            
            local victims = self._victims
            -- 死亡处理
            for i=1, #victims do

                local victim = victims[i]
                local info = self._victimInfos[victim:getLocation()]

                if victim:getIdentity() ~= self._attackers.release_knight:getIdentity() then
                    
                    local key = self._shootEntrySet and self._shootEntrySet[victim] or victim

                    -- 死亡
                    if not info.is_live then

                        self._victimEntrySet:addOnceEntryToQueue(nil, function()
                            -- 敌方挂了
                            -- 先隐藏血条
                            -- 再关闭呼吸动作
                            -- 删除所有的buff
                            victim:setIsDead()
                            victim:setHPVisible(false)
                            victim:setOrderVisible(false)
                            victim:setNameVisible(false)
                            victim:setStarVisible(false)
                            victim:setAngerVisible(false)
                            victim:setBreathAniEnabled(false)
                            victim:setShadowVisible(false)
                            victim:delAllBuffs()

                            return true

                        end, nil, key)
                        
                        if not victim.isBoss then
                            -- 再来是死亡动画
                            local deadEntry = ActionEntry.new(victim:getCardConfig().dead_action, victim, battleField)

                            -- -- 音效
                            -- deadEntry:addEntryToNewQueue(nil, function()
                            --     local deadSound = victim:getCardConfig().dead_sound ~= "0" and victim:getCardConfig().dead_sound or nil
                            --     if deadSound then
                            --         G_AudioManager:playSound(deadSound)
                            --     end
                            --     G_AudioManager:playSound(require("app.const.AudioConst").BattleSound.BATTLE_DEAD)
                            --     return true
                            -- end)

                            self._victimEntrySet:addEntryToQueue(deadEntry, deadEntry.updateEntry, nil, key)
                        else
                            local check = nil
                            self._victimEntrySet:addEntryToQueue(nil, function(_, frameIndex)
                                if not check then check = victim:playDead() end
                                return check(frameIndex)
                            end, nil, key)
                        end

                        -- 死亡通知
                        self._victimEntrySet:addOnceEntryToQueue(nil, function()
                            -- 抛事件出去
                            battleField:dispatchEvent(battleField.BATTLE_SOMEONE_DEAD, victim:getIdentity(), victim:getCardConfig().id)
                            return true
                        end, nil, key)

                    else
                        -- 开启呼吸动画
                        self._victimEntrySet:addOnceEntryToQueue(nil, function()
                            victim:setBreathAniEnabled(true)
                            return true
                        end, nil, key)
                    end

                    -- 掉落动画，现在掉落不区分是否是在死亡后，死亡后也有可能，未死亡也有可能（日常副本打的过程中会掉宝箱）
                    -- 先判断品质
                    local awardType = {}
                    info.awards = info.awards or {}

                    for i=1, #info.awards do
                        local award = info.awards[i]

                        local resource = resource_manager.get(award.type)
                        assert(resource, "Could not find the resource from resource_manager with type: "..tostring(award.type))

                        if resource.battle_type == 6 then
                            local goods = fragment_info.get(award.value)
                            if goods.fragment_type == 1 then
                                awardType[#awardType + 1] = 1
                            elseif goods.fragment_type == 2 then
                                awardType[#awardType + 1] = 2
                            end
                        else
                            awardType[#awardType + 1] = resource.battle_type
                        end
                    end

                    if #awardType > 0 then
                        
                        local entrySet = Entry.new()
                        self._victimEntrySet:addEntryToQueue(entrySet, entrySet.updateEntry, nil, key)

                        for i=1, #awardType do

                            local boxNode = nil
                            if awardType[i] == 3 then boxNode = battleField:getItemBox()
                            elseif awardType[i] == 1 then boxNode = battleField:getKnightBox()
                            elseif awardType[i] == 2 then boxNode = battleField:getEquipBox()
                            end
                            
                            if boxNode then

                                -- 掉落动画
                                self._awardEntry = self._awardEntry or {}

                                local AwardEntry = require "app.scenes.battle.entry.AwardEntry"
                                -- 单独建一个唯一的key，表示此掉落的唯一标识
                                local victimKey = tostring(victim:getIdentity())..victim:getLocation()..i
                                self._awardEntry[victimKey] = AwardEntry.create(awardType[i], victim, battleField)
                                -- self._awardEntry[victimKey]:addEntryToNewQueue(nil, function()
                                --     G_AudioManager:playSound(require("app.const.AudioConst").BattleSound.BATTLE_BOX)
                                --     return true
                                -- end)
                                entrySet:addEntryToQueue(self._awardEntry[victimKey], EntryWrapper.entryDelay((i-1) * 3, self._awardEntry[victimKey].updateEntry), nil, i)
                                -- 这里调用的动画需要保存起来，因为所创建的对象后面还要使用
                                self._awardEntry[victimKey]:retainEntry()

                                local displayNode = nil                        
                                local start = nil
                                local distance = nil
                                local scaleFactor = nil

                                -- 掉落之后的移动
                                entrySet:addEntryToQueue(nil, function(_, frameIndex)

                                    if not displayNode then
                                        displayNode = self._awardEntry[victimKey]:getObject()
                                        scaleFactor = boxNode:getScale()

                                        start = displayNode:convertToWorldSpaceAR(cc.p(0, 0))
                                        local boxPosition = boxNode:convertToWorldSpace(cc.p(boxNode:getContentSize().width/2, boxNode:getContentSize().height/2))
                                        distance = cc.pSub(boxPosition, start)
                                    end

        --                                displayNode:setPosition(displayNode:getParent():convertToNodeSpace(cc.pAdd(start, cc.pMul(distance, frameIndex / 8))))
                                    displayNode:setPosition(displayNode:getParent():convertToNodeSpace(cc.p(start.x + distance.x * frameIndex/8, start.y + distance.y * frameIndex/8)))
                                    displayNode:setScale((scaleFactor - 1) * frameIndex / 8 + 1)

                                    if frameIndex == 8 then
                                        self._awardEntry[victimKey]:releaseEntry()
                                        self._awardEntry[victimKey] = nil

                                        local awardCountNode = nil
                                        if awardType[i] == 3 then awardCountNode = battleField:getItemBoxCount()
                                        elseif awardType[i] == 1 then awardCountNode = battleField:getKnightBoxCount()
                                        elseif awardType[i] == 2 then awardCountNode = battleField:getEquipBoxCount()
                                        end

                                        awardCountNode:setString(tostring(tonumber(awardCountNode:getString()) + 1))
                                        awardCountNode:setScale(1 / scaleFactor)
                                        awardCountNode:stopActionByTag(100)

                                        local action = cc.Sequence:create{
                                            cc.ScaleBy:create(0.2, 2),
                                            cc.DelayTime:create(0.1),
                                            cc.ScaleBy:create(0.2, 0.5)
                                        }
                                        action:setTag(100)
                                        awardCountNode:runAction(action)

                                        return true
                                    end

                                    return false

                                end, nil, i)
                            end
                        end
                    end

                    -- 然后移除英雄（如果死亡的话）
                    if not info.is_live then
                        self._victimEntrySet:addOnceEntryToQueue(battleField, battleField._removeKnight, nil, key, victim)
                    end

                    if self._shootEntrySet and self._shootEntrySet[victim] then
                        self._victimEntrySet:addOnceEntryToQueue(nil, function()
                            self._shootEntrySet[victim]:releaseEntry()
                            self._shootEntrySet[victim] = nil
                            return true
                        end, nil, self._shootEntrySet[victim])
                    end
                end
            end

            -- -- 法宝合击状态变化
            -- -- 这里保存一下identity，因为victims[1]可能会死亡，然后就是野指针了
            -- local identity = self._victims[1]:getIdentity()
            -- self:addOnceEntryToQueue(nil, function()
            --     for k, victim in pairs(knights[identity]) do
            --         local match = battleField:isKnightUniteSkillReady(victim)
            --         if match and not victim:isCardBaseUpgrade() then
            --             local check = victim:playBaseUpgrade()
            --             if check then
            --                 victim:upgradeCardBase(true)
            --                 self:insertEntryToQueueAtTop(nil, function(_, frameIndex)
            --                     return check(frameIndex)
            --                 end, nil, victim)
            --             end
            --         elseif not match then
            --             local check = victim:stopBaseUpgrade()
            --             if check then
            --                 victim:upgradeCardBase(false)
            --                 self:insertEntryToQueueAtTop(nil, function(_, frameIndex)
            --                     return check(frameIndex)
            --                 end, nil, victim)
            --             end
            --         end
            --     end
            --     return true
            -- end, nil, "victimEntrySet")

        else
            -- 默认的仍然走原来的
            CounterAttackEntry.super._onAttackerEvent(self, event, target, frameIndex)
        end
    end

end

return CounterAttackEntry