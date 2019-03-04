--[====================[
    好友Pk场景
    tom
]====================]

--local BattleSummaryLayer = require "app.scenes.battle.summary.BattleSummaryLayer"
local BattleResultLayer = require "app.scenes.battle.result.panel.BattleResultLayer"
local FriendPkScene = class("FriendPkScene", function()
    return display.newScene("FriendPkScene")
end)

function FriendPkScene:ctor(battleReport)
    self:addChatFloatNode()
    self:addtUserBattleListener()--添加全局的事件侦听
	local battleData = {}
    battleData.msg = battleReport.report
    local BattleLayer = require "app.scenes.battle.BattleLayer"
    battleData.skip = BattleLayer.SkipConst.SKIP_YES  --允许跳过
    battleData.battleBg = G_Url:getImage_battleBg("bg000005")
    local battleLayer = nil

    battleLayer = BattleLayer.create(battleData, function (event,identity,location,damage)
        if event == BattleLayer.BATTLE_FINISH then

            local battleResult = BattleResultLayer.new(
                G_FunctionConst.FUNC_FRIEND,
                battleReport.report,
                -- {
                --     isWin = battleReport.report.is_win,
                --     report = battleReport.report
                -- },
                function()
                    G_ModuleDirector:popModule()
                end
            )
            display.getRunningScene():addToPopupLayer(battleResult)

        -- 主角卡牌入场完成后播放全力一击或者普通一击动画
        elseif event == BattleLayer.BATTLE_HERO_ENTER_FINISH then

        elseif event == BattleLayer.BATTLE_DAMAGE_UPDATE then
            
        end
    end)

    self:addChild(battleLayer)
    battleLayer:play()

end

return FriendPkScene

