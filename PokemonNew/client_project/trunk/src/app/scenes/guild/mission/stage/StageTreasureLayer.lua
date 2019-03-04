--
-- Author: wyx
-- Date: 2018-04-27 20:30:44
--[[帮派副本开宝箱界面]]

local StageTreasureLayer=class("StageTreasureLayer",function()
	return cc.Layer:create()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local TreasureCell = require("app.scenes.guild.mission.stage.TreasureCell")
local ConfirmAlert = require("app.common.ConfirmAlert")
local GuildMissionConst = require("app.scenes.guild.mission.GuildMissionConst")
local EffectNode = require("app.effect.EffectNode")
local SchedulerHelper = require "app.common.SchedulerHelper"

function StageTreasureLayer:ctor(chapterId,initIdex)
	-- body
	self:enableNodeEvents()
	self._csbNode = nil
	self._chapterId = chapterId
	self._initIdex = nil--initIdex or 1
	self._topUnits = {}

	self._inited = false
	self._boxs = nil --宝箱数据
end

function StageTreasureLayer:init( ... )
	if self._inited then
		return
	end

	self:_initData()
	self:_initUI()
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUILD_RECV_REWARD,self._recvReward,self)
	--uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUILD_RECV_REWARD,self._refreshUI,self)
	self._inited = true
end

function StageTreasureLayer:_initData()
	self._stageData = {}
	self._chapter = G_Me.guildMissionData:getChapterDataById(self._chapterId)
	local stages = self._chapter:getStages()

	--boss位置放中间，数据稍作处理
	local temp = nil
	for i=1,#stages do
		if i ~= 3 and i < 5 then
			self._stageData[i] = stages[i]
		elseif i == 3 then
			temp = stages[i]
		elseif i == 5 then
			self._stageData[3] = stages[i]
		end
	end
	self._stageData[5] = temp
end

function StageTreasureLayer:_refreshUI()
	self:_initData()
    self:_selectItem(self._curIndex,self._stageData[self._curIndex]:isFinished())
end


--UI界面初始化
function StageTreasureLayer:_initUI()
	-- 排版
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("MissionTreasureLayer", "guild/mission"))
	self:addChild(self._csbNode)
	self._csbNode:setContentSize(display.width,display.height)
	ccui.Helper:doLayout(self._csbNode)

	self._btn_back = self._csbNode:getSubNodeByName("Button_back")
	local bg= self._csbNode:getSubNodeByName("Image_bg")
    G_WidgetTools.autoTransformBg(bg)

    self._csbNode:updateButton("Button_help",function ()
        G_Popup.newHelpPopup(G_FunctionConst.FUNC_UNION_FUBEN)
    end)

    self._tipNode = self._csbNode:getSubNodeByName("Node_tip")
    self._tipNode:setVisible(false)

    local btn_preview = self._csbNode:updateButton("Button_review",function ( ... )
    	G_Popup.newPopup(function ( ... )
    		local pop = require("app.scenes.guild.mission.pop.RewardBookPopup").new(self._chapterId)
    		return pop
    	end)
    end)
    UpdateButtonHelper.reviseButton(btn_preview)

	--------------------list  start
	self._totalNum = 48--G_Me.guildMissionData:getBoxNum()
	self._listNum = self._totalNum%3 == 0 and self._totalNum/3 or self._totalNum/3 + 1

	local listCon = self._csbNode:getSubNodeByName("Panel_con")
	
	

	local listSize = listCon:getContentSize()
	self._viewList = require("app.ui.WListView").new(listSize.width, listSize.height, listSize.width, 166, true)
    self._viewList:setFirstCellPaddigTop(10)
    self._viewList:setCreateCell(function(view, idx)
        local cell = TreasureCell.new(handler(self, self._onCallback))
        return cell
    end)

    self._viewList:setUpdateCell(function(view, cell, idx)
        cell:updateCell(idx,self._boxs,self._totalNum) --cell下标从0开始
    end)
    listCon:addChild(self._viewList)
	
	--------------------list  end

    self._btn_back:addClickEventListenerEx(function( ... )
    	-- G_ModuleDirector:popModule()
    	self:removeFromParent(true)
    end)
    self:_initTopList()
    dump(self._initIdex)
    self:_selectItem(self._initIdex or 1,self._stageData[self._initIdex or 1]:isFinished())
end

function StageTreasureLayer:_initTopList()
	local unit_width = 96
	local blank = 17
	local list_node = self._csbNode:getSubNodeByName("Node_top_icon")
	for i=1,5 do
		local unit = self:_getTopUnit():addTo(list_node)
		local posX = 92 + (i - 1)*(unit_width + blank)
		unit:setPosition(posX, 0)
		unit.index = i
		self:_updateTopUnit(unit)
		self._topUnits[i] = unit
	end
end

function StageTreasureLayer:_updateList(index)
	print("StageTreasureLayer:_updateList")
	self._curIndex = index
	local stage = self._stageData[index]
	self._stageId = stage:getID()
	self._boxs = stage:getBoxs()
	dump(self._boxs)
	self._viewList:setCellNums(self._listNum, true)
end

--
function StageTreasureLayer:_onCallback(boxId,sender)
	local stage = self._stageData[self._curIndex]
	if stage and stage:isFinished() then
		self._sender = sender
		if stage:isGotAward() ~= true then -- 未领取宝箱才放特效
			local effectNode = require("app.scenes.team.TeamUtils").playEffect("effect_bpfb_baoxiang_kai",{x=90.27,y=142.23},sender,"finish")
			sender:getParent():getSubNodeByName("Node_open"):setVisible(true)
			sender:getParent():getSubNodeByName("Node_close"):setVisible(false)
			sender:getParent():getSubNodeByName("Node_icon"):setVisible(false)
		end

		G_HandlersManager.guildHandler:sendGetReward(GuildMissionConst.REWARD_TYPE_STAGE,self._chapterId,self._stageId,boxId)
	else
		G_Popup.tip(G_Lang.get("mission_guild_stage_no_finish"))
	end
end

function StageTreasureLayer:_showTips(isFinish)
	if isFinish then
		self:_awardTip_killed()
	else
		self:_awardTip_alive()
	end
end

function StageTreasureLayer:_awardTip_killed()
	local cdTime = 0
	local curTime = G_ServerTime:getTime()
	if self._countKey ~= nil then
		SchedulerHelper.cancelCountdown(self._countKey)
	end
	self._tipNode:updateLabel("Text_tip", {
		text = G_Lang.get("mission_guild_cd_reward_tip2"),
		textColor = G_Colors.getColor(24),
		outlineColor = G_Colors.getOutlineColor(26),
		})

	local resetTime = G_Me.guildMissionData:getResetTime()
	--local resetTime = G_Me.guildMissionData:getClosedTime()
 	cdTime = resetTime - curTime
	--self._tipNode:setVisible(cdTime > 0)

 	if cdTime > 0 then
 		self._countKey = SchedulerHelper.newCountdown(cdTime, 1, 
        function ()
            cdTime = resetTime - G_ServerTime:getTime()--cdTime - 1
            self._tipNode:setVisible(true)
            self._tipNode:updateLabel("Text_time", {
            	text = GlobalFunc.fromatHHMMSS(cdTime),
            	textColor = G_Colors.getColor(6),
            	outlineColor = G_Colors.getOutlineColor(26),
            	})
        end, 
        function ()
            SchedulerHelper.cancelCountdown(self._countKey)
            self._tipNode:setVisible(false)
        end, 
        nil)
 	end
end

function StageTreasureLayer:_awardTip_alive()
	local cdTime = 0
	local curTime = G_ServerTime:getTime()
	if self._countKey ~= nil then
		SchedulerHelper.cancelCountdown(self._countKey)
	end
	self._tipNode:updateLabel("Text_tip", {
		text = G_Lang.get("mission_guild_cd_reward_tip1"),
		textColor = G_Colors.getColor(24),
		outlineColor = G_Colors.getOutlineColor(26),
		})

	local resetTime = G_Me.guildMissionData:getClosedTime()
 	cdTime = resetTime - curTime
	--self._tipNode:setVisible(cdTime > 0)

 	if cdTime > 0 then
 		self._countKey = SchedulerHelper.newCountdown(cdTime, 1, 
        function ()
            cdTime = resetTime - G_ServerTime:getTime()--cdTime - 1
            self._tipNode:setVisible(true)
            self._tipNode:updateLabel("Text_time", {
            	text = GlobalFunc.fromatHHMMSS(cdTime),
            	textColor = G_Colors.getColor(6),
            	outlineColor = G_Colors.getOutlineColor(26),
            	})
        end, 
        function ()
            SchedulerHelper.cancelCountdown(self._countKey)
            self._tipNode:setVisible(false)
        end, 
        nil)
 	end
end

function StageTreasureLayer:_selectItem(index,isFinish)
	if index == self._curIndex then
		return
	end
	print("···")
	self:_showTips(isFinish)
	--选中状态
	for i=1,#self._topUnits do
		local unit = self._topUnits[i]
		if unit.effect_select then
			unit.effect_select:setVisible(false)
		end
	end

	local unitNode = self._topUnits[index]
	local alive_node = unitNode:getSubNodeByName("Node_alive")
	local box_node = unitNode:getSubNodeByName("Node_box")

	--添加选中效果
	local select_node = unitNode:getSubNodeByName("Node_effect_select")

	if not unitNode.effect_select then
		local effect = EffectNode.new("effect_ui_kuang_red")
		select_node:addChild(effect)
		effect:play()
		effect:setScale(0.8)
		effect:setPosition(1,2.2)
		unitNode.effect_select = effect
	end

	if unitNode.effect_select then
		unitNode.effect_select:setVisible(true)
	end

	--刷新列表
	self:_updateList(index)
end

function StageTreasureLayer:_updateTopUnit(unitNode)
	local index = unitNode.index
	local stage = self._stageData[index]
	local isFinish = stage:isFinished()
	unitNode:updatePanel("Panel_touch", {
		callback = function ()
			dump(index)
			self:_selectItem(index,isFinish)
		end
		})

	local alive_node = unitNode:getSubNodeByName("Node_alive")
	local box_node = unitNode:getSubNodeByName("Node_box")
	alive_node:setVisible(not isFinish)
	box_node:setVisible(isFinish)

	local cfg = stage:getCfg()
	local color = G_TypeConverter.quality2Color(cfg.quality)
	unitNode:updateLabel("Text_stage_name", {
		text = cfg.stage_name,
		textColor = G_Colors.qualityColor2Color(color,true),
		outlineColor = G_Colors.qualityColor2OutlineColor(color)
		})

	if not isFinish then
		self:_renderUnitAlive(alive_node,stage)
	else
		self:_renderUnitBox(box_node,stage,index)
	end
end

function StageTreasureLayer:_renderUnitAlive(node,data)
	--hp
	local bar = node:getSubNodeByName("LoadingBar_hp")
	bar:setPercent(data:getHpPercent())

	--shape
	local cfgData = data:getCfg()
	local params = {
        type = G_TypeConverter.TYPE_KNIGHT,
        value = cfgData.knight_id,
        quality = cfgData.quality,
        sizeVisible = false,
        levelVisible = false,
        nameVisible = false,
        scale = 0.8,
    }
    UpdateNodeHelper.updateCommonIconKnightNode(node:getSubNodeByName("Node_icon"),params,function(sender,params)
        
    end)
end

function StageTreasureLayer:_renderUnitBox(node,data,index)
	dump(data)
	local gotState = data:isGotAward()
	node:getSubNodeByName("Image_box"):setVisible(not gotState)
	node:getSubNodeByName("Image_box_empty"):setVisible(gotState)
	node:updateLabel("Text_get_reward", {
		text = gotState == true and "已领取" or  "可领取",
		textColor = gotState == true and G_Colors.getColor(24) or G_Colors.getColor(13),
		outlineColor = G_Colors.getOutlineColor(26),
		})

	if gotState == false then
		dump(index)
		if self._initIdex == nil then
			self._initIdex = index
		end
		if data:getStageFlag() then
			self._initIdex = index
		end
	end
end

function StageTreasureLayer:_getTopUnit()
	local node = cc.CSLoader:createNode(G_Url:getCSB("TreasureBoxNode1", "guild/mission/common"))
	return node
end

function StageTreasureLayer:_enterStage()
    self:removeFromParent()
end

--type:奖励类型1.章节奖励，2，关卡奖励
function StageTreasureLayer:_recvReward(type)
	if type == 1 then
        return
    end
    self:_initData()
    local stages = self._chapter:getStages()

    --boss位置放中间，数据稍作处理
	local temp = nil
	for i=1,#stages do
		if i ~= 3 and i < 5 then
			self._stageData[i] = stages[i]
		elseif i == 3 then
			temp = stages[i]
		elseif i == 5 then
			self._stageData[3] = stages[i]
		end
	end
	self._stageData[5] = temp

    dump(self._curIndex)
    local stage = self._stageData[self._curIndex]
    local topUnit = self._topUnits[self._curIndex]
	self:_updateTopUnit(topUnit)
	self._boxs = stage:getBoxs()
	dump(self._boxs)
	--self._viewList:setCellNums(self._listNum, false)
	self._viewList:updateCellNums(self._listNum)

	if self._sender then
		--local effectNode = require("app.scenes.team.TeamUtils").playEffect("effect_bpfb_baoxiang_kai",{x=90.27,y=142.23},self._sender,"finish")
	end
end

function StageTreasureLayer:onEnter()
	self:init()
end

function StageTreasureLayer:onExit()
	uf_eventManager:removeListenerWithTarget(self)
	if self._csbNode then
		self._csbNode:removeFromParent(true)
		self._csbNode = nil
	end
	if self._countKey then
		SchedulerHelper.cancelCountdown(self._countKey)
		self._countKey = nil
	end

	self._topUnits = {}
	self._chapterId = nil
	self._inited = false
end

return StageTreasureLayer