----=========================
----主线气泡弹窗
---==========================
local MissionBubblePopNode = class("MissionBubblePopNode", function ()
	return display.newNode()
end)

local CommonBubble = require "app.common.CommonBubble"

MissionBubblePopNode.WORDS_REMAIN_TIME = 3 ---点击之后停留三秒
---==============
---@bubbleType 气泡类型
---@leftSide 要弹窗的英雄是否在屏幕的左半边
---@overCall 结束之后的回调
function MissionBubblePopNode:ctor(bubbleText, leftSide, overCall)
	self._bubbleText = bubbleText
	self._leftSide = leftSide
	self._fadeTag = 66 --淡出标记
	self._overCall = overCall
	self._usingNode = nil
	self._content = nil
	self:enableNodeEvents()
end

function MissionBubblePopNode:onEnter()
	self._content = cc.CSLoader:createNode(G_Url:getCSB("MissionBubleNode", "missionnew"))
	self:addChild(self._content)

	local leftNode = self._content:getSubNodeByName("Node_left")
	local rightNode = self._content:getSubNodeByName("Node_right")
	local startAngle = self._leftSide and -50 or 130

	leftNode:setVisible(not self._leftSide)
	rightNode:setVisible(self._leftSide)
	self._usingNode = self._leftSide and rightNode or leftNode

	self:updateWords()

	---弹出效果
	self._usingNode:setRotation(startAngle)
	self._usingNode:setScale(0)
	self._usingNode:setVisible(true)
	local scaleAction = cc.ScaleTo:create(0.3,1)
	local rotationAction = cc.RotateTo:create(0.3,0)
	local spawn = cc.Spawn:create(scaleAction,rotationAction)
	spawn = cc.EaseBackOut:create(spawn)
	self._usingNode:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),spawn))
end


function MissionBubblePopNode:onExit()
	self:removeChild(self._content)
	self:stopActionByTag(self._fadeTag)
	self._overCall = nil
end

---更新当前显示的文本
function MissionBubblePopNode:updateWords()
	-- if self._bubbleText == nil and showWords == nil then
	-- 	return
	-- end
	-- if showWords == nil then
	-- 	showWords = CommonBubble.getWordsByType(self._bubbleText)
	-- end

	self._usingNode:updateLabel("Label_speak_words", self._bubbleText)

	---设置消失延时
	self:stopActionByTag(self._fadeTag)
	local fadeAct = self:performWithDelay(function ()
		if self._overCall then
			self._overCall()
		end
	end, MissionBubblePopNode.WORDS_REMAIN_TIME)
	fadeAct:setTag(self._fadeTag)
end

return MissionBubblePopNode