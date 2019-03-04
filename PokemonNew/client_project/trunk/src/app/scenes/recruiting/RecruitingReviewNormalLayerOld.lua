------=============
---普通招募预览面板
--====================
local RecruitingReviewBaseLayer = require "app.scenes.recruiting.RecruitingReviewBaseLayer"
local RecruitingReviewNormalLayerOld = class("RecruitingReviewNormalLayerOld", RecruitingReviewBaseLayer)
local RecruitingReviewKnightNode = require "app.scenes.recruiting.RecruitingReviewKnightNode"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local TypeConverter = require "app.common.TypeConverter"
local RecruitingConfigConst = require "app.const.RecruitingConfigConst"
local ItemInfo = require "app.cfg.item_info"
local RecruitingShowNormalSingleLayer = require "app.scenes.recruiting.RecruitingShowNormalSingleLayer"
local RecruitingShowNormalMultyLayer = require "app.scenes.recruiting.RecruitingShowNormalMultyLayer"

RecruitingReviewNormalLayerOld.KNIGHT_SHOW_TYPE = 1

function RecruitingReviewNormalLayerOld:ctor()
	RecruitingReviewNormalLayer.super.ctor(self)
    self.__cname = "RecruitingReviewNormalLayer"
end

function RecruitingReviewNormalLayerOld:onEnter()
    RecruitingReviewNormalLayerOld.super.onEnter(self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECRUITING_NORMAL_ONCE, self._showNormalGet, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECRUITING_NORMAL_TEN, self._showNormalTenGet, self)

    
    self:updateLabel("Text_review_title", {
        text = G_LangScrap.get("recruiting_show_review"), 
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
    })

end

function RecruitingReviewNormalLayerOld:onExit()
    RecruitingReviewNormalLayer.super.onExit(self)
    uf_eventManager:removeListenerWithTarget(self)
end

function RecruitingReviewNormalLayerOld:_initView()
	RecruitingReviewNormalLayerOld.super._initView(self)
    --self._view:getSubNodeByName("Button_previews"):setVisible(false)
	self:updateButton("Button_previews", function ()
        G_Popup.newPopup(function()
            return require("app.scenes.recruiting.RecruitingHandbookPanel").new(k,w)
        end)
    end)

	local oneTimesNode = self._view:getSubNodeByName("Node_one_times")
	oneTimesNode:updateLabel("Text_cost_disc", {
        text = 1,
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        })
   	UpdateButtonHelper.updateBigButton(
        oneTimesNode:getSubNodeByName("Button_call"),{
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
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
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

   	local oneTimeMidNode = self._view:getSubNodeByName("Node_one_times_mid")
   	oneTimeMidNode:updateLabel("Text_cost_disc", {
        text = 1,
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        })
   	UpdateButtonHelper.updateBigButton(
        oneTimeMidNode:getSubNodeByName("Button_call"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_LangScrap.get("recruiting_one_times"),
        callback = function ()
            self:_onOneTimeCall()
        end
    })

   	local tenTimeNode = self._view:getSubNodeByName("Node_ten_times")
   	tenTimeNode:updateLabel("Text_cost_disc", {
        text = 10,
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        })
    UpdateButtonHelper.updateBigButton(
        tenTimeNode:getSubNodeByName("Button_call"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        redPoint = true,
        desc = G_LangScrap.get("recruiting_ten_times"),
        callback = function ()
            self:_onTenTimeCall()
        end
    })

    local discCon = self:getSubNodeByName("Node_tips")
    local discTxt = ccui.RichText:createWithContent(G_LangScrap.get("recruiting_normal_tips"))
    discTxt:formatText()
    discTxt:setAnchorPoint(0.5, 0)
    discCon:addChild(discTxt)

    self:_updateView()
end

function RecruitingReviewNormalLayerOld:_updateView()
	local itemData = ItemInfo.get(RecruitingConfigConst.NORMAL_PROP_ID)
    local itemNum = G_Me.recruitingData:getNormalPropNum()
    local normalFreeCount = G_Me.recruitingData:getNormalFreeCount()
    local coolingTime = G_Me.recruitingData:getNormalFreeTime()
    local serverTime = G_ServerTime:getTime()
    local isFree = normalFreeCount > 0 and coolingTime <= serverTime

    -- self:updateLabel("Text_item_disc", {
    --     text = G_LangScrap.get("recruiting_item_title", {item = itemData.name}),
    --     outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
    --     })
    self:updateLabel("Text_item_value", {
        text = tostring(itemNum),
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
        })

    local oneTimesNode = self._view:getSubNodeByName("Node_one_times")
    oneTimesNode:setVisible(itemNum >= 10 and not isFree)

    local oneTimesFreeNode = self._view:getSubNodeByName("Node_one_times_free")
    oneTimesFreeNode:setVisible(isFree)

    local oneTimeMidNode = self._view:getSubNodeByName("Node_one_times_mid")
    oneTimeMidNode:setVisible(itemNum < 10 and not isFree)

 	local tenTimeNode = self._view:getSubNodeByName("Node_ten_times")
 	tenTimeNode:setVisible(itemNum >= 10 and not isFree)
end

function RecruitingReviewNormalLayerOld:_onOneTimeCall()
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

function RecruitingReviewNormalLayerOld:_onTenTimeCall()
	local propNum = G_Me.recruitingData:getNormalPropNum()
    if propNum >= 10 then
        ---检查背包武将是否满
        if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) then
            G_HandlersManager.recruitingHandler:sendRecruitLpTen(RecruitingConfigConst.TYPE_PROP)
        end
    else
        G_Popup.tip(G_LangScrap.get("recruiting_not_enough_prop"))
    end
end


function RecruitingReviewNormalLayerOld:_showNormalGet(param)
    local normalPropNum = G_Me.recruitingData:getNormalPropNum()
    local price = {
        type = TypeConverter.TYPE_ITEM,
        value = RecruitingConfigConst.NORMAL_PROP_ID,
        size = 1}

    if self._showLayer == nil then
        self._showLayer = RecruitingShowNormalSingleLayer.new()
        self._showLayer:setAwards(param.awards)
        self._showLayer:setProp(price, 1)
        self._showLayer:setBoughtCopper(param.money)
        self._showLayer:setOneMoreCallback(function ()
            self:_onOneTimeCall()
        end)
        self:_showAwardsLayer()
    else
        self._showLayer:freshView(param.awards)
    end
    
    self:_updateView()
end

function RecruitingReviewNormalLayerOld:_showNormalTenGet(param)
    local normalPropNum = G_Me.recruitingData:getNormalPropNum()
    local priceType = normalPropNum >= 10 and TypeConverter.TYPE_ITEM or TypeConverter.TYPE_GOLD
    local price = {
        type = priceType,
        value = RecruitingConfigConst.NORMAL_PROP_ID,
        size = 10}

    self._showLayer = RecruitingShowNormalMultyLayer.new()
    self._showLayer:setAwards(param.awards)
    self._showLayer:setBoughtCopper(param.money)
    self:_showAwardsLayer()
    self:_updateView()
end

---获取武将展示的类型
function RecruitingReviewNormalLayerOld:_getKnightShowType()
	return RecruitingReviewNormalLayer.KNIGHT_SHOW_TYPE
end


return RecruitingReviewNormalLayerOld