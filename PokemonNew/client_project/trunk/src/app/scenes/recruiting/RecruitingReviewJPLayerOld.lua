------=============
---高级招募预览面板
--====================
local RecruitingReviewBaseLayer = require "app.scenes.recruiting.RecruitingReviewBaseLayer"
local RecruitingReviewJPLayerOld = class("RecruitingReviewJPLayerOld", RecruitingReviewBaseLayer)
local RecruitingReviewKnightNode = require "app.scenes.recruiting.RecruitingReviewKnightNode"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local TypeConverter = require "app.common.TypeConverter"
local RecruitingConfigConst = require "app.const.RecruitingConfigConst"
local ItemInfo = require "app.cfg.item_info"

local RecruitingShowNormalSingleLayer = require "app.scenes.recruiting.RecruitingShowNormalSingleLayer"
local RecruitingShowNormalMultyLayer = require "app.scenes.recruiting.RecruitingShowNormalMultyLayer"

RecruitingReviewJPLayerOld.KNIGHT_SHOW_TYPE = 2

function RecruitingReviewJPLayerOld:ctor()
	RecruitingReviewJPLayerOld.super.ctor(self)
    self.__cname = "RecruitingReviewJPLayer"
    self._isWaittingServer = false
	self._goldOneTimeCost = G_Me.recruitingData:getJPCost()
	self._goldTenTimeCost = G_Me.recruitingData:getJPTenCost()
end

function RecruitingReviewJPLayerOld:onEnter()
    RecruitingReviewJPLayerOld.super.onEnter(self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECRUITING_JP_ONCE, self._showJPGet, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECRUITING_JP_TEN, self._showJPTenGet, self)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false)

    
    self:updateLabel("Text_review_title", {
        text = G_LangScrap.get("recruiting_show_review"), 
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
    })

end

function RecruitingReviewJPLayerOld:onExit()
    RecruitingReviewJPLayerOld.super.onExit(self)
    uf_eventManager:removeListenerWithTarget(self)

    if self._effectBackground then
        self._effectBackground:removeFromParent()
        self._effectBackground = nil
    end

end
    
function RecruitingReviewJPLayerOld:_initView()
	RecruitingReviewJPLayerOld.super._initView(self)
    --self._view:getSubNodeByName("Button_previews"):setVisible(false)
	self:updateButton("Button_previews", function ()
        G_Popup.newPopup(function()
            return require("app.scenes.recruiting.RecruitingHandbookPanel").new(2)
        end)
    end)

	local oneTimeItemNode = self._view:getSubNodeByName("Node_one_times_item")
	oneTimeItemNode:updateLabel("Text_cost_disc", {
        text = 1,
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
    })
   	UpdateButtonHelper.updateBigButton(
        oneTimeItemNode:getSubNodeByName("Button_call"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        redPoint = true,
        desc = G_LangScrap.get("recruiting_one_times"),
        callback = function ()
            self:_onOneTimeCall()
        end
    })

    local oneTimesFreeNode = self._view:getSubNodeByName("Node_one_times_free")
    oneTimesFreeNode:updateLabel("Text_cost_disc", {
        text = G_LangScrap.get("recruiting_free_this_time"),
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
    })
    UpdateButtonHelper.updateBigButton(
        oneTimesFreeNode:getSubNodeByName("Button_call"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        redPoint = true,
        desc = G_LangScrap.get("recruiting_one_times"),
        callback = function ()
            self:_onOneTimeCall()
        end
    })

   	local oneTimeGoldNode = self._view:getSubNodeByName("Node_one_times")
   	oneTimeGoldNode:updateLabel("Text_cost_disc", {
        text = self._goldOneTimeCost,
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
    })
   	UpdateButtonHelper.updateBigButton(
        oneTimeGoldNode:getSubNodeByName("Button_call"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_LangScrap.get("recruiting_one_times"),
        callback = function ()
            self:_onOneTimeCall()
        end
    })

   	local tenTimeNode = self._view:getSubNodeByName("Node_ten_times")
   	tenTimeNode:updateLabel("Text_cost_disc", {
        text = self._goldTenTimeCost,
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
    })
    UpdateButtonHelper.updateBigButton(
        tenTimeNode:getSubNodeByName("Button_call"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_LangScrap.get("recruiting_ten_times"),
        callback = function ()
            self:_onTenTimeCall()
        end
    })

    local tenTimeItemNode = self._view:getSubNodeByName("Node_ten_times_item")
    tenTimeItemNode:updateLabel("Text_cost_disc", {
        text = 10,
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
    })
    UpdateButtonHelper.updateBigButton(
        tenTimeItemNode:getSubNodeByName("Button_call"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        redPoint = true,
        desc = G_LangScrap.get("recruiting_ten_times"),
        callback = function ()
            self:_onTenTimeCall()
        end
    })

    local discCon = self:getSubNodeByName("Node_tips")
    local discTxt = ccui.RichText:createWithContent(G_LangScrap.get("recruiting_jp_tips"))
    discTxt:formatText()
    discTxt:setAnchorPoint(0.5, 0)
    discCon:addChild(discTxt)

    self:_updateView()
end

function RecruitingReviewJPLayerOld:_updateView()
	local itemData = ItemInfo.get(RecruitingConfigConst.SS_PROP_ID)
    local itemNum = G_Me.recruitingData:getJPPropNum()
    local isFree = G_Me.recruitingData:isJpFree()
    
    self._view:updateLabel("Text_item_disc", { 
        text = G_LangScrap.get("recruiting_item_title", {item = itemData.name}),
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
    })
    self._view:updateLabel("Text_item_value", { 
        text = tostring(itemNum),
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
    })

    local oneTimesNode = self._view:getSubNodeByName("Node_one_times")
    oneTimesNode:setVisible(itemNum < 1 and not isFree)

    local oneTimeItemNode = self._view:getSubNodeByName("Node_one_times_item")
    oneTimeItemNode:setVisible(itemNum >= 1 and not isFree)

    local oneTimesFreeNode = self._view:getSubNodeByName("Node_one_times_free")
    oneTimesFreeNode:setVisible(isFree)

    local tenTimeNode = self._view:getSubNodeByName("Node_ten_times")
    tenTimeNode:setVisible(not isFree and itemNum < 10)

    local tenTimeItemNode = self._view:getSubNodeByName("Node_ten_times_item")
    tenTimeItemNode:setVisible(itemNum >= 10 and not isFree)

    local recruitedTimes = G_Me.recruitingData:getJpRecruitedTimes()
    local roundTime = RecruitingConfigConst.THE_JP_ROUND_TIME

    local needTime = roundTime - recruitedTimes % roundTime

    self._view:updateLabel("Text_buy_tips", {
        text = G_LangScrap.get("recruiting_jp_buy_tips"),
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        visible = recruitedTimes <= 50
    })

    local tipsStr
    if needTime  == 1 then
        tipsStr = G_LangScrap.get("recruiting_jp_this_time")
    else
        tipsStr = G_LangScrap.get("recruiting_jp_need_time", {time = needTime - 1})
    end

    local tipsCon = self._view:getSubNodeByName("Node_num_tips")
    local tipsTxt = ccui.RichText:createWithContent(tipsStr)
    tipsCon:removeAllChildren()
    tipsTxt:formatText()
    tipsTxt:setAnchorPoint(0.5, 0)
    tipsCon:addChild(tipsTxt)
end

function RecruitingReviewJPLayerOld:_onOneTimeCall(isMustUseItem)

    if self._isWaittingServer then return end

	local isFree = G_Me.recruitingData:isJpFree()
    local needGold = G_Me.recruitingData:getJPCost()

    local recruitType
    if isFree then
        recruitType = RecruitingConfigConst.TYPE_FREE
    else
        local jpPropNum = G_Me.recruitingData:getJPPropNum()
        if jpPropNum > 0 then
            recruitType = RecruitingConfigConst.TYPE_PROP
        elseif isMustUseItem then --只能使用道具招募，而且道具数量不足时
            G_Popup.tip(G_LangScrap.get("recruiting_not_enough_prop"))
            return
        else
            recruitType = RecruitingConfigConst.TYPE_GOLD
            G_Responder.enoughGold(needGold, function()
                ---检查背包武将是否满
                if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) then
                    G_HandlersManager.recruitingHandler:sendRecruitJp(recruitType)
                    self._isWaittingServer = true
                end
            end)
            return
        end
    end
     ---检查背包武将是否满
    if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) then
        G_HandlersManager.recruitingHandler:sendRecruitJp(recruitType)
        self._isWaittingServer = true
    end
end

function RecruitingReviewJPLayerOld:_onTenTimeCall(useProp)

    if self._isWaittingServer then return end

	local jpPropNum = G_Me.recruitingData:getJPPropNum()

     if jpPropNum >= 10 then
        if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) then
                G_HandlersManager.recruitingHandler:sendRecruitJpTen(RecruitingConfigConst.TYPE_PROP)
                self._isWaittingServer = true
        end
     else
        local needGold = G_Me.recruitingData:getJPTenCost()
        G_Responder.enoughGold(needGold,function()
            ---检查背包武将是否满
            if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) then
                G_HandlersManager.recruitingHandler:sendRecruitJpTen(RecruitingConfigConst.TYPE_GOLD)
                self._isWaittingServer = true
            end
        end)
     end
end

function RecruitingReviewJPLayerOld:_showJPGet(param)
    local jpPropNum = G_Me.recruitingData:getJPPropNum()
    local isMustUseItem = jpPropNum > 0 ---是否这次连抽必须使用道具
    local priceType = isMustUseItem and TypeConverter.TYPE_ITEM or TypeConverter.TYPE_GOLD
    local callSize = priceType == TypeConverter.TYPE_ITEM and 1 or self._goldOneTimeCost
    local price = {
        type = priceType,
        value = RecruitingConfigConst.SS_PROP_ID,
        size = callSize}

    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false)

    if self._showLayer == nil then
        self._showLayer = RecruitingShowNormalSingleLayer.new()
        self._showLayer:setAwards(param.awards)
        self._showLayer:setProp(price, callSize)
        self._showLayer:setBoughtCopper(param.money)
        self._showLayer:setOneMoreCallback(function ()
            self:_onOneTimeCall(isMustUseItem)
        end)
        self:_showAwardsLayer()
    else
        self._showLayer:freshView(param.awards)
    end

    self:_updateView()
    self._isWaittingServer = false
end


function RecruitingReviewJPLayerOld:_showJPTenGet(param)
    local price = {
        type = TypeConverter.TYPE_GOLD,
        value = RecruitingConfigConst.SS_PROP_ID,
        size = G_Me.recruitingData:getJPTenCost()}

    self._showLayer = RecruitingShowNormalMultyLayer.new()
    self._showLayer:setAwards(param.awards)
    self._showLayer:setBoughtCopper(param.money)
    self:_showAwardsLayer()

    self:_updateView()
    self._isWaittingServer = false
end

---获取武将展示的类型
function RecruitingReviewJPLayerOld:_getKnightShowType()
	return RecruitingReviewJPLayerOld.KNIGHT_SHOW_TYPE
end

return RecruitingReviewJPLayerOld