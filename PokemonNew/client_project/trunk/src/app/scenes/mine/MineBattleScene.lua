--
-- Author: yutou
-- Date: 2018-09-20 20:11:30
--
--

local TypeConverter = require "app.common.TypeConverter"
local BattleResultLayer = require("app.scenes.battle.result.panel.BattleResultLayer")
local FunctionConst = require("app.const.FunctionConst")

local MineBattleScene=class("MineBattleScene",function()
	return display.newScene("MineBattleScene")
end)

function MineBattleScene:ctor(pack,isReview,isSkip,callBack)
	self:enableNodeEvents()
	self._isReview = isReview
	self._callBack = callBack
	if isSkip == nil then
		self._isSkip = false
	else
		self._isSkip = isSkip
	end
	self._pack = pack
	self:addtUserBattleListener()--添加全局的事件侦听
	self:addChatFloatNode()
end

function MineBattleScene:_initUI(pack)
	local msg = {}
	local battle_report = pack or {}
	local BattleLayer = require("app.scenes.battle.BattleLayer")
	msg.battleType = BattleLayer.MINE_BATTLE
	msg.msg = battle_report
	if self._isSkip == true then
		msg.skip = BattleLayer.SkipConst.SKIP_YES  --允许跳过
	else
		msg.skip = BattleLayer.SkipConst.SKIP_NO  --允许跳过
	end
	msg.battleBg = G_Url:getImage_battleBg("bg000006")
	local awards = nil

	local resultLayer = nil
	-- local BattleSummaryLayer = require("app.scenes.battle.summary.BattleSummaryLayer")

	local battleLayer = nil
	battleLayer = BattleLayer.create(msg, function (event) 
	    if event == BattleLayer.BATTLE_START then

	        print("battle started!")

	    elseif event == BattleLayer.BATTLE_ENTER_FINISH then

	    elseif event == BattleLayer.BATTLE_FINISH then
			local resultPanel = nil
		    resultPanel = BattleResultLayer.new(
		        FunctionConst.FUNC_MINE,
		        battle_report,
		        function()
		        	-- if self._isReview == true then -- 战报用于
		        		if self._callBack then
		        			self._callBack()
		        		end
		        		G_ModuleDirector:popModule()
	    			 	return
		        	-- end
		        end
		    )
	        display.getRunningScene():addToPopupLayer(resultPanel)
	    end
	end)

	self:addChild(battleLayer)
	battleLayer:play()

end


function MineBattleScene:onEnter( ... )
	self:_initUI(self._pack)
end

function MineBattleScene:onExit( ... )
	-- self.data_=nil
end

return MineBattleScene