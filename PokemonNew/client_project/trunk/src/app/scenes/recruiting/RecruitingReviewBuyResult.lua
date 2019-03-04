--
-- Author: Your Name
-- Date: 2017-05-16 14:27:54
--
------=============
---普通招募预览面板
--====================
local RecruitingReviewBuyResult = class("RecruitingReviewNormalLayer", function ()
	return display.newLayer()
end)

local RecruitingReviewKnightNode = require "app.scenes.recruiting.RecruitingReviewKnightNode"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local TypeConverter = require "app.common.TypeConverter"
local RecruitingConfigConst = require "app.const.RecruitingConfigConst"

RecruitingReviewNormalLayer.KNIGHT_SHOW_TYPE = 1

function RecruitingReviewBuyResult:ctor(recruitType)
	self.recruitType = recruitType
	self:enableNodeEvents()
	self:_initView()
end

function RecruitingReviewBuyResult:onEnter()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECRUITING_NORMAL_ONCE, self._showNormalGet, self)
end

function RecruitingReviewBuyResult:onExit()
    uf_eventManager:removeListenerWithTarget(self)
end

function RecruitingReviewBuyResult:_initView()
	local rootNode = cc.CSLoader:createNode(G_Url:getCSB("RecruitingReviewBuyResult", "recruiting"))
	self:addChild(rootNode)

	local oneTimesNode = self._view:getSubNodeByName("Node_one_times")
	oneTimesNode:updateLabel("Text_cost_disc", {
        text = 1,
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        })
   	UpdateButtonHelper.updateBigButton(
        oneTimesNode:getSubNodeByName("Button_call"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_LangScrap.get("recruiting_one_times_again"),
        callback = function ()
            self:_onOneTimeCallAgain()
        end
    })

   	local closeNode = self._view:getSubNodeByName("Node_close")
   	
    UpdateButtonHelper.updateBigButton(
        closeNode:getSubNodeByName("Button_call"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_LangScrap.get("recruiting_close"),
        callback = function ()
            self:_closeUI()
        end
    })

end

function RecruitingReviewBuyResult:_onOneTimeCallAgain()
	local normalFreeCount = G_Me.recruitingData:getNormalFreeCount()
    local coolingTime = G_Me.recruitingData:getNormalFreeTime()
    local serverTime = G_ServerTime:getTime()
    local propNum = G_Me.recruitingData:getNormalPropNum()

    local recruitType
    if normalFreeCount > 0 and coolingTime <= serverTime then
        recruitType = RecruitingConfigConst.TYPE_FREE
    elseif propNum > 0 then
        recruitType = RecruitingConfigConst.TYPE_PROP
    else
        G_Popup.tip(G_LangScrap.get("recruiting_not_enough_prop"))
        return
    end

    ---检查背包武将是否满
    if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) then
        G_HandlersManager.recruitingHandler:sendRecruitLp(recruitType)
    end
end

function RecruitingReviewBuyResult:_closeUI()
    self:removeFromParent()
end

-- 收到消息后的显示
function RecruitingReviewBuyResult:_showNormalGet(param)
    local normalPropNum = G_Me.recruitingData:getNormalPropNum()
    -- local price = {
    --     type = TypeConverter.TYPE_ITEM,
    --     value = RecruitingConfigConst.NORMAL_PROP_ID,
    --     size = 1}

    local nodeMid = self._view:getSubNodeByName("Node_mid")
    nodeMid:removeAllChildren()
	local knightInfo = KnightInfo.get(118011)
	local knightNode = RecruitingReviewKnightNode.new(118011, 1,
		nil, nil,false)

	----初始化位置到屏幕右边或者中间
	knightNode:setPosition(0, 0)
	knightNode:setScale(0.9)
	nodeMid:addChild(knightNode)

    -- if self._showLayer == nil then
    --     self._showLayer = RecruitingShowNormalSingleLayer.new()
    --     self._showLayer:setAwards(param.awards)
    --     self._showLayer:setProp(price, 1)
    --     self._showLayer:setBoughtCopper(param.money)
    --     self._showLayer:setOneMoreCallback(function ()
    --         self:_onOneTimeCall()
    --     end)
    --     self:_showAwardsLayer()
    -- else
    --     self._showLayer:freshView(param.awards)
    -- end
    
    self:_updateView()
end

function RecruitingReviewBuyResult:_updateView()

end

return RecruitingReviewBuyResult