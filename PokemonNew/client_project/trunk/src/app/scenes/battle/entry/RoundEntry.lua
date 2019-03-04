
-- RoundEntry

local CounterAttackEntry = require "app.scenes.battle.entry.CounterAttackEntry"

local RoundEntry = class("RoundEntry", require "app.scenes.battle.entry.Entry")
local Entry = require "app.scenes.battle.entry.Entry"
local BattleFieldConst = require "app.scenes.battle.BattleFieldConst"
local AudioConst = require "app.const.AudioConst"
local ActionEntry = require "app.scenes.battle.entry.ActionEntry"

function RoundEntry:initEntry()
    
    RoundEntry.super.initEntry(self)
    
    local round = self._data
    local knights = self._objects
    local battleField = self._battleField

    local AttackEntry = require "app.scenes.battle.entry.AttackEntry"
    --local TurnEntry = require "app.scenes.battle.entry.TurnEntry"
    
    local attackIndex = 0
    
    local function nextAttack()
        
        attackIndex = attackIndex + 1
        
        local attackData = round.attacks[attackIndex]
        if not attackData then return true end
        
        local nextSttackData = round.attacks[attackIndex + 1]
        local nextCombo = 0
        if nextSttackData and 
            nextSttackData.combo and
            attackData.attack_pos.order == nextSttackData.attack_pos.order and 
            attackData.attack_pos.pos == nextSttackData.attack_pos.pos 
         then
            nextCombo = nextSttackData.combo
        end

        -- local bsKnight = knights[attackData.attack_pos.order][tostring(attackData.attack_pos.pos)]
        -- local bsconf = G_BSableKnightId[bsKnight:getCardConfig().id]
        -- if bsconf and round.round_index >= bsconf.round then
        --     -- 武将变身
        --     --if G_BSableKnightId[bsKnight:getCardConfig().id] and bsKnight:getAngerAmount() >= 4 then
        --     if G_BSableKnightId[bsKnight:getCardConfig().id] then
        --         print("武将变身")
        --         --local bsKnight = knights[attackData.attack_pos.order][tostring(attackData.attack_pos.pos)]
        --         if not bsKnight:getIsBS() then
        --             local turn = TurnEntry.new(attackData, knights, self._battleField)
        --             self:addEntryToQueue(turn, turn.updateEntry)
        --             bsKnight:setIsBS()
        --         end
        --     end
        -- end
        -- 
        -- if bsKnight:getIsBS() then
        --     local skillId = attackData.skill_id
        --     attackData.skill_id = (skillId and G_SkillReplaceAfterBs[skillId]) or skillId
        -- end

        -- 1表示技能攻击，2表示反击攻击，3表示天赋技能
        if attackData.type == 1 or attackData.type == 3 then
            local attack = AttackEntry.new(attackData, knights, battleField,nextCombo)
            self:addEntryToQueue(attack, attack.updateEntry)
        elseif attackData.type == 2 then--把在一起的反击统一做处理
            local attackDatas = {}
            repeat
                attackDatas[#attackDatas + 1] = attackData
                attackIndex = attackIndex + 1
                attackData = round.attacks[attackIndex]
            until not attackData or attackData.type ~= 2

            -- 最后一个是不合格的，所以要-1剔除掉
            attackIndex = attackIndex - 1

            local attack = CounterAttackEntry.new(attackDatas, knights, battleField)
            self:addEntryToQueue(attack, attack.updateEntry)
        else
            assert(false, "Unknown attack type: "..tostring(attackData.type))
        end

        if not attackData then return true end
        
        self:addOnceEntryToQueue(nil, nextAttack)
        battleField:dispatchEvent(battleField.BATTLE_SOMEONE_ATTACK, attackData.attack_pos.order, attackData.attack_pos.pos, knights[attackData.attack_pos.order][tostring(attackData.attack_pos.pos)]:getCardConfig().id)
        
        return true
    end
    
    self:addOnceEntryToQueue(nil, nextAttack)

end

return RoundEntry