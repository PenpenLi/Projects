
--=================
--招募预览的武将显示
---
local RecruitingReviewKnightNode = class("RecruitingReviewKnightNode", function ()
	return display.newNode()
end)

local KnightInfo = require "app.cfg.knight_info"
local KnightImg = require "app.common.KnightImg"
-- local knightRankInfo = require "app.cfg.knight_rank_info"
local TeamUtils = require "app.scenes.team.TeamUtils"
local CommonBubble = require "app.common.CommonBubble"

---=====
---@knightId 展示的武将ID
---@rankLv 武将突破等级
---@移动结束所需时间
---@onMoveOver 移动完毕之后调用
function RecruitingReviewKnightNode:ctor(knightId, moveTime, onMoveOver,reviewType)
	self._knightId = knightId
	--self._knightId = 11801
	self._onMoveOver = onMoveOver
	self._moveTime = moveTime
	self._moveTag = 66
	self._view = nil
	self._knight = nil
	self._touchPanel = nil
	self._reviewType = reviewType
	--self._isNeedMoving = isMove
	self:enableNodeEvents()
end

function RecruitingReviewKnightNode:onEnter()
	self:_initView()
end

function RecruitingReviewKnightNode:onExit()
	self._onMoveOver = nil
	self:stopActionByTag(self._moveTag)
	self:removeChild(self._view)
	self:removeChild(self._knight)
end

function RecruitingReviewKnightNode:_initView()
	
	self._view = cc.CSLoader:createNode(G_Url:getCSB("RecruitingReviewKnightNode", "recruiting"))
	self:addChild(self._view,1)
	local knightData = KnightInfo.get(self._knightId)
	assert(knightData, "can't find knightId in knight_info " .. self._knightId)

	-- 名字
	local colorQuility = G_TypeConverter.quality2Color(knightData.quality)
	self._view:updateLabel("Text_name", {
		text=knightData.name, 
		color = G_Colors.qualityColor2Color(colorQuility,true),
		outlineColor = G_Colors.qualityColor2OutlineColor(colorQuility)
	})
	-- 种族
	self._view:updateImageView("Image_group", {texture = TeamUtils.getGroupImgUrl(knightData.group)})
	-- 形象
	local k_starLvl,ex_starLvl = 0,0
	if self._reviewType == 2 and knightData.quality >= 10 then
		k_starLvl,ex_starLvl = 15,3
	end
	self._knight = KnightImg.new(self._knightId,k_starLvl,ex_starLvl) --knightRankData.res_id
	self._knight:showShaddow(false)
	self._knight:setScale(1.4)
	self:addChild(self._knight)

	---根据当前位置判断是否需要弹出气泡
	--if self._isNeedMoving == false then return end
	local seq
	local currentPosX = self:getPositionX()
	local overCall = cc.CallFunc:create(function () --移动结束
		self._onMoveOver()
		self:removeFromParent()
	end)

	if currentPosX < 10 and currentPosX > -10 then ---起始位置在屏幕中间，直接弹出气泡
		self:_popBubble()
		local moveAction = cc.MoveTo:create(self._moveTime, 
			cc.p(-display.width, 0))
		seq = cc.Sequence:create(moveAction, overCall)
	else	--起始位置在屏幕外面，到屏幕中再弹气泡
		local midX = (currentPosX - display.width) * 0.5
		local moveAction1 = cc.MoveTo:create(self._moveTime * 0.5, 
			cc.p(midX, 0))
		local showBubbleAct = cc.CallFunc:create(function ()
			self:_popBubble()
		end)
		local moveAction2 = cc.MoveTo:create(self._moveTime * 0.5, 
			cc.p(-display.width, 0))
		seq = cc.Sequence:create(moveAction1, showBubbleAct, moveAction2, overCall)
	end

	self:runAction(seq)
	seq:setTag(self._moveTag)

	self._touchPanel = ccui.Layout:create()
	self._touchPanel:setTouchEnabled(true)
	self._touchPanel:setAnchorPoint(0.5, 0)
	self._touchPanel:setContentSize(240, 356)
	self._touchPanel:setPosition(0, -50)
	self:addChild(self._touchPanel)
	self._touchPanel:addTouchEventListenerEx(function (sender, event)
		-- if event == ccui.TouchEventType.ended then
		-- 	local startPos = sender:getTouchBeganPosition()
		-- 	local endPos = sender:getTouchEndPosition()
  --         	if (startPos.x - endPos.x) * (startPos.x - endPos.x) + 
  --         	    (startPos.y - endPos.y) * (startPos.y - endPos.y) <= 200 then
  --         		uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_RECRUITING_SHOW_KNIGHT, nil, false, self._knightId)
  --         	end
		-- end
	end)
end

function RecruitingReviewKnightNode:_popBubble()
	local bubbleContent = cc.CSLoader:createNode(G_Url:getCSB("RecruitingBubbleNode", "recruiting"))
	local knightInfo = KnightInfo.get(self._knightId)
	assert(knightInfo, "invalide knightid of knight_info" .. tostring(self._knightId))

	bubbleContent:updateLabel("Label_speak_words", knightInfo.talk)
	self:addChild(bubbleContent)
	bubbleContent:setPosition(50, 200)

	---添加气泡弹出效果
	bubbleContent:setRotation(-50)
	bubbleContent:setScale(0)
	local scaleAction = cc.ScaleTo:create(0.3,1)
	local rotationAction = cc.RotateTo:create(0.3,0)
	local spawn = cc.Spawn:create(scaleAction,rotationAction)
	spawn = cc.EaseBackOut:create(spawn)
	bubbleContent:runAction(spawn)
end

return RecruitingReviewKnightNode