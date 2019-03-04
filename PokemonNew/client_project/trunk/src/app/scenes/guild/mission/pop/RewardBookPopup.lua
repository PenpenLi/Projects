--
-- Author: wyx
-- Date: 2018-04-29 11:40:50
--
--RewardBookPopup.lua

--[====================[

    帮派副本关卡奖励图鉴
    
]====================]

local RewardBookPopup =  class("RewardBookPopup",function()
    return cc.Node:create()
end)

local UpdateNodeHelper = require ("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require ("app.common.UpdateButtonHelper")
local SchedulerHelper = require "app.common.SchedulerHelper"

local REWARD_HEIGHT = 110
local REWARD_WIDTH = 92

function RewardBookPopup:ctor(chapterId,index)
	assert(type(chapterId) == "number","invalid chapterId :"..chapterId)
	self:enableNodeEvents()
	self._curTabIndex = index or 1
	self._chapterId = chapterId
	self._rewardIcons = {}
	self:_initData()
end

function RewardBookPopup:_initData()
	self._chapter = G_Me.guildMissionData:getChapterDataById(self._chapterId)
	self._stages = self._chapter:getStages()
end


function RewardBookPopup:_initUI( ... )
    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("RewardBookPopup","guild/mission/pop"))
    self:addChild(self._csbNode)
    self._csbNode:setContentSize(display.width,display.height)
    self:setPosition(display.cx,display.cy)
    ccui.Helper:doLayout(self._csbNode) 

    UpdateNodeHelper.updateCommonNormalPop(self,"奖励",nil,580)

    local close_btn = self._csbNode:updateButton("Button_sure",function ( ... )
    	self:removeFromParent()
    end)
    UpdateButtonHelper.reviseButton(close_btn,{isBig = true})
    self:_showTips()
    self:_initReward()
    self:_initTabBtns()
end

function RewardBookPopup:_showTips()
    local text_tips = self._csbNode:getSubNodeByName("Text_tip")

    text_tips:getVirtualRenderer():setLineHeight(30)

    local serverTime = G_ServerTime:getTime()
    local closeTime = G_Me.guildMissionData:getClosedTime()
    self._txtTime = self._csbNode:updateLabel("Text_time", {
        text = "00:00:00",
        textColor = G_Colors.getColor(21)
        })
    
    if closeTime > serverTime then
        --todo
        if self._normalTimeDown then
            SchedulerHelper.cancelCountdown(self._normalTimeDown)
            self._normalTimeDown = nil
        end
        local coolTime = closeTime - serverTime
        self._normalTimeDown = SchedulerHelper.newCountdown(coolTime, 1, 
        function ()
            coolTime = coolTime - 1
            self._txtTime:setString(G_Lang.get("recruiting_free_when", {time = GlobalFunc.fromatHHMMSS(coolTime)}))
        end, 
        function ()
            self._txtTime:setString("00:00:00")
        end, 
        nil)
    end
end

function RewardBookPopup:_initReward()
	local root = self._csbNode:getSubNodeByName("Node_reward")
	local posX,posY = 0,0
	local blankX,blankY = 40,5
	local row = 0
	for i=1,6 do
		local icon = self:_createRewardIcon():addTo(root)
		self._rewardIcons[i] = icon

		local row = i%3 == 0 and math.floor(i/3) or math.floor(i/3) + 1 -- 1 start
        row = 3 - row -- 从上往下
		local col = i%3 == 0 and 3 or i%3

		posX = 125 + (col - 1) * (REWARD_WIDTH + blankX)
		posY = 25 + (row - 1) * (REWARD_HEIGHT + blankY)
		icon:setPosition(posX, posY)
	end
end

--初始化tab按钮
function RewardBookPopup:_initTabBtns()
    local nodeTabButtons = self._csbNode:getSubNodeByName("FileNode_tab")
    nodeTabButtons:setVisible(true)    

    --tab页签按钮数组
    local tabs = {}

    for i=1, 5 do
    	local stage = self._stages[i]
        tabs[i] =  {text = stage:getName()}
    end

    local params = {
        tabs = tabs,
        defaultIndex = self._curTabIndex,
        isBig = false,
        scrollRect = cc.rect(10, 0, 470, 0)
    }
    
    self._tabButtons = require("app.common.TabButtonsHelper").updateTabButtons(nodeTabButtons,params,handler(self,self._onTabBtnChange))
end

function RewardBookPopup:_onTabBtnChange(index)

    self._curTabIndex = index
	self._stage = self._stages[index]
	--dump(self._stage)

    self:_updateView()
end

function RewardBookPopup:_updateView()
	self:_updateReward()
end

function RewardBookPopup:_updateReward()
	local rewards = self._stage:getRewards()
	dump(rewards)
	for i=1,6 do
		local icon = self._rewardIcons[i]
		self:_updateRewardIcon(icon,rewards[i])
	end
end

function RewardBookPopup:_updateRewardIcon(node,data)
	if not data then
		return
	end

	local param = { 
        type = data.type,
        size = data.size,
        value = data.value,
        nameVisible=false,
        levelVisible=false,
        sizeVisible=true,
        scale = 0.8,
    }
	UpdateNodeHelper.updateCommonIconKnightNode(node:getSubNodeByName("Node_icon"),param)

	--num
	node:updateLabel("Text_reward", {
		text = G_Lang.get("mission_guild_reward_num",{maxNum = data.maxNum,curNum = data.maxNum - data.used_num}),
		textColor = G_Colors.getColor(2)
		})
end

function RewardBookPopup:_createRewardIcon()
    local node = cc.CSLoader:createNode(G_Url:getCSB("RewardNode", "guild/mission/pop"))
    return node
end


function RewardBookPopup:_updateKnightIcon(node, index, knightId, quality, conHeight)
    local color = G_TypeConverter.quality2Color(quality)
    local param = { 
        type=TypeConverter.TYPE_KNIGHT,
        value=knightId,
        nameVisible=true,
        levelVisible=false,
        sizeVisible=false,
        scale = 0.8,
        fontSize = 22,
    }

    UpdateNodeHelper.updateCommonIconKnightNode(node, param)

    local posX = self._width/(ONE_LINE_NUM * 2)+2 + ((index-1)%ONE_LINE_NUM) * self._width/ONE_LINE_NUM
    local posY = conHeight - 60 - math.floor((index-1)/ONE_LINE_NUM) * 130
    node:setPosition(posX, posY)
end


function RewardBookPopup:onEnter()
    self:_initUI()
end


function RewardBookPopup:onExit()
    if self._csbNode ~= nil then
        self._csbNode:removeFromParent(true)
        self._csbNode = nil
    end
    if self._normalTimeDown then
        SchedulerHelper.cancelCountdown(self._normalTimeDown)
        self._normalTimeDown = nil
    end
end

return RewardBookPopup