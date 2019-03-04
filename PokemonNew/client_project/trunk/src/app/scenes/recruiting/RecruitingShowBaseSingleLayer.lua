
----=============
---招募展示界面，单个招募展示的基类

local RecruitingShowBaseLayer = require "app.scenes.recruiting.RecruitingShowBaseLayer"
local RecruitingShowBaseSingleLayer = class("RecruitingShowBaseSingleLayer", RecruitingShowBaseLayer)

local UpdateButtonHelper = require "app.common.UpdateButtonHelper"

function RecruitingShowBaseSingleLayer:ctor(recruitType)
	RecruitingShowBaseSingleLayer.super.ctor(self,RecruitingShowBaseLayer.RecruitypeOne,recruitType)

	self._onOneMoreTime = nil
end

function RecruitingShowBaseSingleLayer:setOneMoreCallback(onOneMoreTime)
	self._onOneMoreTime = onOneMoreTime
end

---刷新当前获得的招募奖励
function RecruitingShowBaseSingleLayer:freshView(awards)
	-- self._rootNode:removeAllChildren()
	-- self._endEffectNode:removeAllChildren()
	-- self._awards = awards
	-- self._rootNode:setPosition(0, 0)
	-- self:_showAwards()
end

function RecruitingShowBaseSingleLayer:_getStarFrameIndex()
	return 52
end

--展示底部节点
function RecruitingShowBaseSingleLayer:_showBottomNode(onShowOver)
	local bottomNode = self:_createBottomNode()

	local bottomSize = bottomNode:getSubNodeByName("Panel_content"):getContentSize()
	self._endEffectNode:addChild(bottomNode)
	bottomNode:setPosition(display.cx, bottomSize.height * -1)

	local tagY = (display.width / display.height < 0.75) and -120 or -100
	local moveAct = cc.EaseInOut:create(cc.MoveTo:create(0.2, cc.p(bottomNode:getPositionX(), tagY)), 2.5)
	local moveOver = cc.CallFunc:create(function ()
		if onShowOver ~= nil then
			onShowOver()
		end
		uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,204)
    	print("EVENT_GUIDE_STEPEVENT_GUIDE_STEPEVENT_GUIDE_STEP22",203)
    	-- uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1528)
	end)

	local seq = cc.Sequence:create(moveAct, moveOver)
	bottomNode:runAction(seq)

	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,203)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1528)
end

--获取底部再来一次节点。
function RecruitingShowBaseSingleLayer:_createBottomNode()
	local bottomNode = cc.CSLoader:createNode(G_Url:getCSB("RecruitingAwardBottomNode", "recruiting"))

	local oneMoreButton = bottomNode:getSubNodeByName("Button_one_more")
	local confirmButton = bottomNode:getSubNodeByName("Button_confirm")
	UpdateButtonHelper.updateBigButton(oneMoreButton, {
    	state = UpdateButtonHelper.STATE_NORMAL,
    	desc = G_Lang.get("lang_recruiting_again_once"), 
    	callback = function ()
    		self._onOneMoreTime()
    	end
    })

    UpdateButtonHelper.updateBigButton(confirmButton, {
    	state = UpdateButtonHelper.STATE_ATTENTION,
    	desc = G_Lang.get("lang_recruiting_confirm"), 
    	callback = function ()
    		self._onClose()
    		self._onClose = nil
			uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,205)
    		uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1528)
    	end
    })

    bottomNode:updateLabel("Text_item_title", G_Lang.get("recruiting_award_end_has"))

    local imgDetail = bottomNode:getSubNodeByName("Image_detail")
    imgDetail:setVisible(false)
    imgDetail:setTouchEnabled(true)
    imgDetail:addClickEventListener(function()
    	--...
    end)

    self:_addOutlines(bottomNode, "Text_item_title", "Text_item_value")
    self:_addOutlines(oneMoreButton, "Text_item_cost")

    return bottomNode
end

function RecruitingShowBaseSingleLayer:_getKnightScaleAfterShow()
	return 1.45
end


return RecruitingShowBaseSingleLayer