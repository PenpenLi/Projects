--
-- Author: wyx
-- Date: 2018-04-23 12:29:06
--[[帮派副本关卡层]]

local MissionStageLayer = class("MissionChapterLayer", function ()
    return display.newLayer()
end)

local StageMonsterItem = require("app.scenes.guild.mission.stage.StageMonsterItem")
local StageBossItem = require("app.scenes.guild.mission.stage.StageBossItem")
local StageTreasureLayer = require("app.scenes.guild.mission.stage.StageTreasureLayer")
local GuildMissionBattleScene = require("app.scenes.guild.mission.GuildMissionBattleScene")
local GuildMissionConst = require("app.scenes.guild.mission.GuildMissionConst")
local EffectNode = require("app.effect.EffectNode")

MissionStageLayer.BG_INDEX = 1
MissionStageLayer.STAGE_INDEX = 2

local MONSTER_SCALE = 0.5
local BOSS_SCALE = 0.6

function MissionStageLayer:ctor(chapterId)
	assert(type(chapterId) == "number", "invalide chapterId " .. tostring(chapterId))
	self._chapterId = chapterId
    self:enableNodeEvents()
    self._background = nil
    self._scroll = nil
    self._monsters = {}
end

function MissionStageLayer:onEnter()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUILD_RECV_EXECUTE_STAGE, self._recvExecute, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUILD_RECV_BROAD_CAST, self._recvBrocast, self)
    --uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUILD_RECV_REWARD, self._updateRewardRedPoint, self)
--    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUILD_GET_CHAPTER_LIST, self._recvList, self) 

    self._scroll = self:_getScoller()
    self:addChild(self._scroll)
    self:initData()
    self:render()
end

function MissionStageLayer:onExit()
    uf_eventManager:removeListenerWithTarget(self)
    self:removeAllChildren(true)
    self:disableNodeEvents()
end

function MissionStageLayer:initData()
	self._chapter = G_Me.guildMissionData:getChapterDataById(self._chapterId)
	self._stages = self._chapter:getStages()
end

function MissionStageLayer:render()
	local cfg = self._chapter:getCfgInfo()
	--加入场景
	--local img_bg = ccui.ImageView:create("newui/guild/mission/stage_map/"..cfg.background..".jpg")
	local mapCsb = cc.CSLoader:createNode(G_Url:getCSB("map01", "guild/mission/map"))
	mapCsb:setContentSize(display.size)
	self._scroll:addChild(mapCsb,MissionStageLayer.BG_INDEX)
    --local effect = EffectNode.createEffect( "effect_lava_map4",cc.p(display.width/2,display.height/2))
    local effect = EffectNode.createEffect( "effect_lava_map4",cc.p(0,0))
    mapCsb:getSubNodeByName("Node_effect"):addChild(effect)

	local y = display.height < 1000 and 1140/display.height * 100 or 0
	mapCsb:setPosition(0,-y)
	self._mapNode = mapCsb
	G_WidgetTools.autoTransformBg(mapCsb:getSubNodeByName("Image_map"))

	local enemyPanel = mapCsb:getSubNodeByName("Panel_enemy")
	local totalH = enemyPanel:getContentSize().height
	--totalH = totalH > display.height and totalH or display.height
	self._scroll:setInnerContainerSize(cc.size(display.width, display.height))

	self:_renderMonster()
	--self:_renderBoss()
	self:_renderTreasuer()
	self:_updateRewardRedPoint()
end

function MissionStageLayer:updateView()
	self:initData()
	for i=1,GuildMissionConst.CHAPTER_STAGE_NUM do
		local monsterItem = self._monsters[i]
		local data = self._chapter:getStageOfStages(monsterItem.data:getID())
		dump(data)
		monsterItem.monster:update(data)
	end
	self:_updateRewardRedPoint()
end

function MissionStageLayer:_renderMonster()
	local scale = MONSTER_SCALE
	for i=1,GuildMissionConst.CHAPTER_STAGE_NUM do
		local data = self._stages[i]
		local root = self._mapNode:getSubNodeByName("Node_"..tostring(i))
		local monster = StageMonsterItem.new():addTo(root)
		--dump(data)
		if i == 5 then
			monster:setMonsterScale(scale)
		end
		monster:update(data)
		self._monsters[i] = {monster = monster,data = data}
	end
end

function MissionStageLayer:_renderBoss()
	local root = self._mapNode:getSubNodeByName("Node_boss")
	local bossItem = StageBossItem.new():addTo(root)
	local data = self._stages[5]
	bossItem:update(data)
	self._monsters[5] = {monster = bossItem,data = data}
end

function MissionStageLayer:_renderTreasuer()
	local node_treasure = self._mapNode:getSubNodeByName("node_treasure")
	--node_treasure:setScale(2)

	-- 宝箱呼吸
	local scale1 =  cc.ScaleTo:create(1.5, 0.9)
    local scale2 =  cc.ScaleTo:create(1.5, 1.10)
    --local scale3 =  cc.ScaleTo:create(1, 0.68)
    local action = cc.Sequence:create(scale1, scale2, scale3)
    local action1 = cc.RepeatForever:create(action)
    --transition.execute(self._image, action1)
    node_treasure:getSubNodeByName("Image_treasure"):runAction(action1)

	local lay = node_treasure:getSubNodeByName("Panel_touch")
	lay:addClickEventListenerEx(function ( ... )
		local layer = StageTreasureLayer.new(self._chapterId)
		display.getRunningScene():addChild(layer,3)
	end,nil,nil,nil,5)
	
	-- lay:addTouchEventListenerEx(function (sender, eventType)
	-- 	if eventType == ccui.TouchEventType.began then
 --          --sender:setScale(StageMonsterItem.SELECT_SCALE)
 --      	elseif eventType == ccui.TouchEventType.ended then
 --          	local moveOffset=math.abs(sender:getTouchEndPosition().y-sender:getTouchBeganPosition().y)
 --          	--sender:setScale(StageMonsterItem.NORMAL_SCALE)
 --          	if moveOffset<= 20 then
 --          		local layer = StageTreasureLayer.new(self._chapterId)
	-- 			display.getRunningScene():addChild(layer,3)
 --          	end
 --      	elseif eventType == ccui.TouchEventType.canceled then
 --      	  --sender:setScale(StageMonsterItem.NORMAL_SCALE)
 --      	end
	-- end)
		
	lay:setSwallowTouches(false)

	node_treasure:updateLabel("Text_name", {
		text = "巨额宝藏",
		textColor = G_Colors.getColor(25), --G_Colors.qualityColor2Color(5,true),
		outlineColor = G_Colors.getOutlineColor(26), --G_Colors.qualityColor2OutlineColor(26)
		})
end

function MissionStageLayer:_getScoller()
    local scrollView = ccui.ScrollView:create()
    scrollView:setTouchEnabled(true)
    scrollView:setContentSize(cc.size(display.width, display.height))
    scrollView:setPosition(0,0)
    scrollView:setScrollBarEnabled(false)

    return scrollView
end

function MissionStageLayer:_updateRewardRedPoint()
	print("_updateRewardRedPoint")
	local node_treasure = self._mapNode:getSubNodeByName("Node_treasure_effect")
	if self._chapter:hasStageAwardRedPoint() then
		if not self._effect then
			local effect = require("app.effect.EffectNode").new("effect_guangshu_all")
			node_treasure:addChild(effect)
			effect:play()
			effect:setPosition(0,35)
			effect:setScale(0.5)
			self._effect = effect
		end
		self._mapNode:getSubNodeByName("Image_red_dot"):setVisible(true)
	elseif self._effect then
		self._effect:removeFromParent()
		self._effect = nil
		self._mapNode:getSubNodeByName("Image_red_dot"):setVisible(false)
	end
end

--========接收数据
function MissionStageLayer:_recvExecute(data)
	print("MissionStageLayer:_recvExecute")
	dump(data)
	if next(data.kill_award) ~= nil then -- boss死亡才关闭弹窗
		dump(data.kill_award)
		uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUILD_MISSION_CLOSE_POP_LAY)
	end
	G_ModuleDirector:pushModuleWithAni(nil, function()
		local battleScene = GuildMissionBattleScene.new(data,function( ... )
					
		end)

		--兼容线上bug, 未知原因导致 self._chapter == nil,重新获取下
		if not self._chapter and self.initData then
			self:initData()
		end
		if self._chapter then
			local stageData = self._chapter:getStageOfStages(data.stage_id)
			battleScene:playBattle(stageData)
		end
		
		return battleScene
	end)
end


--====广播数据
function MissionStageLayer:_recvBrocast()
	print("MissionStageLayer:_recvBrocast")
	--local stageData = self._chapter:getAttackStage()
	--if stageData then
	self:updateView()
		-- for i=1,4 do
		-- 	local monsterItem = self._monsters[i]
		-- 	local data = self._chapter:getStageOfStages(monsterItem.data:getID())
		-- 	dump(data)
		-- 	monsterItem.monster:update(data)
		-- end
	--end
end

return MissionStageLayer